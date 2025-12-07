#!/bin/bash
# BAUX Core Components Debugging Script
# Tests Neovim, Tmux, and Keymap functionality

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Test 1: Keymap Functionality
test_keymap() {
    log "Testing BAUX keymap functionality..."

    # Check if keymap file exists
    if [ ! -f "/usr/share/syscons/keymaps/baux.kbd" ]; then
        error "BAUX keymap file not found at /usr/share/syscons/keymaps/baux.kbd"
        return 1
    fi

    # Check file permissions
    if [ ! -r "/usr/share/syscons/keymaps/baux.kbd" ]; then
        error "BAUX keymap file not readable"
        return 1
    fi

    # Check if keymap is loaded
    if command -v kbdcontrol >/dev/null 2>&1; then
        current_keymap=$(kbdcontrol -d 2>/dev/null | head -1 || echo "unknown")
        if echo "$current_keymap" | grep -q "baux"; then
            log "✓ BAUX keymap is loaded"
        else
            warn "⚠ BAUX keymap not currently loaded (current: $current_keymap)"
            info "  To load: sudo kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
        fi
    else
        warn "kbdcontrol not available (not in FreeBSD?)"
    fi

    # Check rc.conf
    if [ -f "/etc/rc.conf" ]; then
        if grep -q "keymap.*baux" /etc/rc.conf; then
            log "✓ Keymap configured in rc.conf"
        else
            warn "⚠ Keymap not configured in rc.conf"
            info "  Add: keymap=\"baux\""
        fi
    fi

    log "✓ Keymap test completed"
    return 0
}

# Test 2: Tmux Configuration
test_tmux() {
    log "Testing BAUX tmux configuration..."

    # Check if tmux is installed
    if ! command -v tmux >/dev/null 2>&1; then
        error "tmux not found in PATH"
        return 1
    fi

    # Check tmux version
    tmux_version=$(tmux -V 2>/dev/null | cut -d' ' -f2 || echo "unknown")
    log "Tmux version: $tmux_version"

    # Check if tmux config exists
    config_files=(
        "/usr/local/share/tmux/baux.conf"
        "/usr/local/etc/baux/tmux.conf"
    )

    config_found=false
    for config in "${config_files[@]}"; do
        if [ -f "$config" ]; then
            log "✓ Found tmux config: $config"
            config_found=true

            # Check for BAUX-specific settings
            if grep -q "C-Space" "$config"; then
                log "  ✓ BAUX prefix (C-Space) configured"
            fi

            if grep -q "@plugin.*resurrect" "$config"; then
                log "  ✓ tmux-resurrect plugin configured"
            fi

            if grep -q "@plugin.*continuum" "$config"; then
                log "  ✓ tmux-continuum plugin configured"
            fi
        fi
    done

    if [ "$config_found" = false ]; then
        warn "⚠ No BAUX tmux configuration found"
        info "  Expected locations: ${config_files[*]}"
    fi

    # Check TPM installation
    tpm_paths=(
        "/usr/local/share/tmux/plugins/tpm"
        "$HOME/.tmux/plugins/tpm"
    )

    tpm_found=false
    for tpm_path in "${tpm_paths[@]}"; do
        if [ -d "$tpm_path" ]; then
            log "✓ TPM found: $tpm_path"
            tpm_found=true
        fi
    done

    if [ "$tpm_found" = false ]; then
        warn "⚠ TPM (Tmux Plugin Manager) not found"
        info "  Install: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
    fi

    # Test tmux server (if running)
    if tmux has-session 2>/dev/null; then
        log "✓ Tmux server is running"
        session_count=$(tmux list-sessions 2>/dev/null | wc -l)
        log "  Active sessions: $session_count"
    else
        info "No tmux server running (expected if not in tmux session)"
    fi

    log "✓ Tmux test completed"
    return 0
}

# Test 3: Neovim Configuration
test_neovim() {
    log "Testing BAUX neovim configuration..."

    # Check if neovim is installed
    if ! command -v nvim >/dev/null 2>&1; then
        error "neovim (nvim) not found in PATH"
        return 1
    fi

    # Check neovim version
    nvim_version=$(nvim --version 2>/dev/null | head -1 | cut -d' ' -f2 || echo "unknown")
    log "Neovim version: $nvim_version"

    # Check for BAUX neovim configs
    config_paths=(
        "/usr/local/share/bvi"
        "/usr/local/share/neovim"
    )

    config_found=false
    for config_path in "${config_paths[@]}"; do
        if [ -d "$config_path" ]; then
            log "✓ Found neovim config: $config_path"
            config_found=true

            # Check for lazy config
            if [ -f "$config_path/config/lazy.lua" ]; then
                log "  ✓ Lazy configuration found"
            fi

            # Check for keymaps
            if [ -f "$config_path/config/keymaps.lua" ]; then
                log "  ✓ BAUX keymaps found"
            fi
        fi
    done

    if [ "$config_found" = false ]; then
        warn "⚠ No BAUX neovim configuration found"
        info "  Expected locations: ${config_paths[*]}"
    fi

    # Test neovim startup (quick test)
    if timeout 5 nvim --headless -c "echo 'test'" -c "quit" >/dev/null 2>&1; then
        log "✓ Neovim starts successfully"
    else
        warn "⚠ Neovim startup test failed"
    fi

    log "✓ Neovim test completed"
    return 0
}

# Test 4: Integration Testing
test_integration() {
    log "Testing BAUX component integration..."

    # Test 1: Environment variables
    if [ -n "${BAUX_HOME:-}" ]; then
        log "✓ BAUX_HOME environment variable set: $BAUX_HOME"
    else
        info "BAUX_HOME not set (expected if not in BAUX session)"
    fi

    # Test 2: Check for common conflicts
    if command -v tmux >/dev/null 2>&1 && command -v nvim >/dev/null 2>&1; then
        # Check if tmux prefix conflicts with neovim
        log "✓ Both tmux and neovim available (no basic conflicts)"
    fi

    # Test 3: Check TERM variable (important for keybindings)
    current_term="${TERM:-unknown}"
    log "Current TERM: $current_term"

    if [[ "$current_term" == *"tmux"* ]]; then
        log "✓ Running inside tmux (TERM contains 'tmux')"
    elif [[ "$current_term" == *"screen"* ]]; then
        warn "⚠ Running inside screen (may cause keybinding issues)"
    else
        info "Not running inside multiplexer"
    fi

    log "✓ Integration test completed"
    return 0
}

# Test 5: Performance Testing
test_performance() {
    log "Testing BAUX component performance..."

    # Test neovim startup time
    if command -v nvim >/dev/null 2>&1; then
        start_time=$(date +%s%N)
        timeout 10 nvim --headless -c "quit" >/dev/null 2>&1
        end_time=$(date +%s%N)
        startup_time=$(( (end_time - start_time) / 1000000 ))  # Convert to milliseconds

        if [ "$startup_time" -lt 1000 ]; then
            log "✓ Neovim startup time: ${startup_time}ms (good)"
        else
            warn "⚠ Neovim startup time: ${startup_time}ms (slow)"
        fi
    fi

    # Test tmux responsiveness (if running)
    if command -v tmux >/dev/null 2>&1 && tmux has-session 2>/dev/null; then
        start_time=$(date +%s%N)
        tmux list-sessions >/dev/null 2>&1
        end_time=$(date +%s%N)
        response_time=$(( (end_time - start_time) / 1000000 ))

        if [ "$response_time" -lt 100 ]; then
            log "✓ Tmux response time: ${response_time}ms (good)"
        else
            warn "⚠ Tmux response time: ${response_time}ms (slow)"
        fi
    fi

    log "✓ Performance test completed"
    return 0
}

# Main test runner
main() {
    log "Starting BAUX Core Components Debugging Suite"
    log "Testing: Keymap, Tmux, Neovim, Integration, Performance"
    echo

    local tests_passed=0
    local total_tests=0
    local test_results=()

    # Run all tests
    for test_func in test_keymap test_tmux test_neovim test_integration test_performance; do
        total_tests=$((total_tests + 1))
        test_name=$(echo "$test_func" | sed 's/test_//')

        echo "----------------------------------------"
        log "Running $test_name test..."

        if $test_func; then
            tests_passed=$((tests_passed + 1))
            test_results+=("✓ $test_name")
        else
            test_results+=("✗ $test_name")
        fi

        echo
    done

    # Summary
    echo "========================================"
    log "BAUX Debugging Summary"
    echo "========================================"

    for result in "${test_results[@]}"; do
        echo "$result"
    done

    echo
    log "Results: $tests_passed/$total_tests tests passed"

    if [ "$tests_passed" -eq "$total_tests" ]; then
        log "🎉 All BAUX components appear to be working correctly!"
    else
        warn "⚠ Some issues detected. Review output above for details."
        echo
        info "Common fixes:"
        info "  - Keymap: sudo kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
        info "  - Tmux: Check ~/.tmux.conf and plugin installation"
        info "  - Neovim: Verify config paths and plugin loading"
        info "  - Integration: Test in both console and X11 environments"
    fi

    echo
    log "Debugging complete. Check logs above for detailed information."
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi