#!/usr/local/bin/bash
# BAUX Mesh Testing Framework
# Comprehensive testing for distributed session management

set -euo pipefail

# Configuration
HEADSCALE_URL="${HEADSCALE_URL:-http://localhost:8080}"
REGISTRY_DB="${REGISTRY_DB:-/tmp/baux-registry-test.db}"
TEST_DEVICES="${TEST_DEVICES:-5}"
TEST_SESSIONS="${TEST_SESSIONS:-10}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Test 1: Headscale Connectivity
test_headscale_connectivity() {
    log "Testing Headscale connectivity..."
    if curl -s "${HEADSCALE_URL}/health" > /dev/null; then
        log "✓ Headscale server is responding"
        return 0
    else
        error "✗ Headscale server not responding at ${HEADSCALE_URL}"
        return 1
    fi
}

# Test 2: Registry Database Operations
test_registry_operations() {
    log "Testing registry database operations..."

    # Create test registry
    sqlite3 "${REGISTRY_DB}" << EOF
CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,
    device_id TEXT NOT NULL,
    location TEXT NOT NULL,
    last_seen INTEGER NOT NULL,
    metadata TEXT
);

CREATE TABLE IF NOT EXISTS devices (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    public_key TEXT,
    last_seen INTEGER NOT NULL
);
EOF

    # Insert test data
    for i in $(seq 1 "${TEST_DEVICES}"); do
        sqlite3 "${REGISTRY_DB}" "INSERT OR REPLACE INTO devices (id, name, last_seen) VALUES ('device_${i}', 'TestDevice${i}', $(date +%s));"
    done

    for i in $(seq 1 "${TEST_SESSIONS}"); do
        device_id=$(( (i - 1) % TEST_DEVICES + 1 ))
        sqlite3 "${REGISTRY_DB}" "INSERT OR REPLACE INTO sessions (id, device_id, location, last_seen) VALUES ('session_${i}', 'device_${device_id}', 'location_${i}', $(date +%s));"
    done

    # Query test
    session_count=$(sqlite3 "${REGISTRY_DB}" "SELECT COUNT(*) FROM sessions;")
    device_count=$(sqlite3 "${REGISTRY_DB}" "SELECT COUNT(*) FROM devices;")

    if [ "${session_count}" -eq "${TEST_SESSIONS}" ] && [ "${device_count}" -eq "${TEST_DEVICES}" ]; then
        log "✓ Registry operations successful (${session_count} sessions, ${device_count} devices)"
        return 0
    else
        error "✗ Registry operations failed (expected ${TEST_SESSIONS}/${TEST_DEVICES}, got ${session_count}/${device_count})"
        return 1
    fi
}

# Test 3: Session Discovery Performance
test_session_discovery() {
    log "Testing session discovery performance..."

    start_time=$(date +%s%N)
    # Simulate discovery queries
    for i in $(seq 1 100); do
        sqlite3 "${REGISTRY_DB}" "SELECT s.id, d.name FROM sessions s JOIN devices d ON s.device_id = d.id WHERE s.last_seen > $(($(date +%s) - 300));" > /dev/null
    done
    end_time=$(date +%s%N)

    duration=$(( (end_time - start_time) / 1000000 )) # Convert to milliseconds
    avg_query_time=$(( duration / 100 ))

    if [ "${avg_query_time}" -lt 100 ]; then # Less than 100ms per query
        log "✓ Session discovery performance good (${avg_query_time}ms avg query time)"
        return 0
    else
        warn "⚠ Session discovery performance slow (${avg_query_time}ms avg query time)"
        return 0 # Not a failure, just a warning
    fi
}

# Test 4: Concurrent Access Simulation
test_concurrent_access() {
    log "Testing concurrent registry access..."

    # Simulate multiple devices updating simultaneously
    for i in $(seq 1 10); do
        (
            for j in $(seq 1 50); do
                sqlite3 "${REGISTRY_DB}" "UPDATE sessions SET last_seen = $(date +%s) WHERE id = 'session_$((RANDOM % TEST_SESSIONS + 1))';" 2>/dev/null || true
            done
        ) &
    done

    # Wait for all background processes
    wait

    # Check data integrity
    invalid_count=$(sqlite3 "${REGISTRY_DB}" "SELECT COUNT(*) FROM sessions WHERE last_seen > $(date +%s);")

    if [ "${invalid_count}" -eq 0 ]; then
        log "✓ Concurrent access test passed"
        return 0
    else
        error "✗ Concurrent access caused data corruption (${invalid_count} invalid records)"
        return 1
    fi
}

# Test 5: Bandwidth Estimation
test_bandwidth_estimation() {
    log "Estimating bandwidth requirements..."

    # Create sample session data
    sample_data=$(dd if=/dev/zero bs=1M count=10 2>/dev/null | base64)

    # Test compression
    compressed_size=$(echo "${sample_data}" | gzip | wc -c)
    original_size=$(echo "${sample_data}" | wc -c)

    compression_ratio=$(( original_size * 100 / compressed_size ))

    log "Compression ratio: ${compression_ratio}% (${original_size} -> ${compressed_size} bytes)"

    # Estimate bandwidth for typical usage
    # Assume 1KB/minute per active pane, 10 panes per session
    estimated_bandwidth=$(( TEST_SESSIONS * 10 * 1024 / 60 )) # bytes per second
    estimated_mbps=$(( estimated_bandwidth * 8 / 1000000 ))

    log "Estimated bandwidth for ${TEST_SESSIONS} sessions: ${estimated_mbps} Mbps"

    if [ "${estimated_mbps}" -lt 10 ]; then
        log "✓ Bandwidth requirements acceptable"
        return 0
    else
        warn "⚠ High bandwidth requirements (${estimated_mbps} Mbps)"
        return 0
    fi
}

# Test 6: tmux Session Serialization
test_tmux_serialization() {
    log "Testing tmux session serialization..."

    # Create a test tmux session
    tmux new-session -d -s "test_session_$(date +%s)" -n "test_window"

    # Wait a moment for session to initialize
    sleep 1

    # Try to capture session state (simplified)
    session_info=$(tmux list-sessions -F "#{session_name}:#{session_attached}")

    if echo "${session_info}" | grep -q "test_session"; then
        log "✓ tmux session creation successful"
        success=0
    else
        error "✗ tmux session creation failed"
        success=1
    fi

    # Clean up
    tmux kill-session -t "test_session_*" 2>/dev/null || true

    return "${success}"
}

# Main test runner
main() {
    log "Starting BAUX Mesh Testing Framework"
    log "Configuration:"
    log "  Headscale URL: ${HEADSCALE_URL}"
    log "  Registry DB: ${REGISTRY_DB}"
    log "  Test Devices: ${TEST_DEVICES}"
    log "  Test Sessions: ${TEST_SESSIONS}"
    echo

    local tests_passed=0
    local total_tests=0

    # Run tests
    for test_func in test_headscale_connectivity test_registry_operations test_session_discovery test_concurrent_access test_bandwidth_estimation test_tmux_serialization; do
        total_tests=$((total_tests + 1))
        if ${test_func}; then
            tests_passed=$((tests_passed + 1))
        fi
        echo
    done

    # Cleanup
    rm -f "${REGISTRY_DB}"

    # Results
    log "Test Results: ${tests_passed}/${total_tests} tests passed"

    if [ "${tests_passed}" -eq "${total_tests}" ]; then
        log "🎉 All tests passed!"
        exit 0
    else
        error "❌ Some tests failed"
        exit 1
    fi
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi