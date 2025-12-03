#!/bin/bash
# build-all.sh — CoseismicBSD Complete Build System v2.0
# Builds all FreeBSD ports with dependency resolution and debugging
# Converted from Debian debhelper to FreeBSD ports framework

set -euo pipefail

BUILD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$BUILD_ROOT/.build_cache"
LOG_DIR="$BUILD_ROOT/logs"
PARALLEL_JOBS=$(nproc)
MAX_RETRIES=3

# FreeBSD port definitions with dependencies
declare -A PORTS=(
    ["cbsd-base"]="none"
    ["cbsd-terminal"]="cbsd-base"
    ["cbsd-wm"]="cbsd-base cbsd-terminal"
    ["cbsd-editor"]="cbsd-base"
    ["cbsd-fonts"]="cbsd-base"
    ["cbsd-boot-splash"]="cbsd-base"
    ["cbsd-grub"]="cbsd-base"
    ["cbsd-release"]="cbsd-base"
    ["cbsd-kernel"]="none"
    ["cbsd-meta"]="cbsd-base cbsd-terminal cbsd-wm cbsd-editor cbsd-fonts cbsd-boot-splash cbsd-grub cbsd-release cbsd-kernel"
)

# Logging
log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] FREEBSD BUILD: $*" | tee -a "$LOG_DIR/build.log"; }
error() { log "ERROR: $*" >&2; }
success() { log "SUCCESS: $*"; }
warn() { log "WARN: $*"; }

# Get FreeBSD port build order
get_build_order() {
    local built=()
    local queue=("$@")
    local result=()
    local iterations=0
    local max_iterations=$(( ${#PORTS[@]} * 2 ))
    
    while [ ${#queue[@]} -gt 0 ] && [ $iterations -lt $max_iterations ]; do
        ((iterations++))
        local next_batch=()
        
        for port in "${queue[@]}"; do
            local deps="${PORTS[$port]}"
            local can_build=true
            
            if [ "$deps" != "none" ]; then
                for dep in $deps; do
                    if [[ ! " ${built[*]} " =~ " $dep " ]]; then
                        can_build=false
                        break
                    fi
                done
            fi
            
            if $can_build; then
                result+=("$port")
                built+=("$port")
            else
                next_batch+=("$port")
            fi
        done
        
        if [ ${#next_batch[@]} -eq ${#queue[@]} ]; then
            error "Circular dependency detected in: ${next_batch[*]}"
            return 1
        fi
        
        queue=("${next_batch[@]}")
    done
    
    echo "${result[@]}"
}

# Check FreeBSD port
check_port() {
    local port="$1"
    local port_dir="$BUILD_ROOT/ports/$port"
    
    if [ ! -d "$port_dir" ]; then
        error "Port directory $port_dir not found"
        return 1
    fi
    
    if [ ! -f "$port_dir/Makefile" ]; then
        warn "$port missing Makefile"
        return 1
    fi
    
    return 0
}

# Build FreeBSD port
build_port() {
    local port="$1"
    local port_dir="$BUILD_ROOT/ports/$port"
    local cache_file="$CACHE_DIR/${port}.pkg"
    local log_file="$LOG_DIR/${port}.log"
    local retries=0
    
    log "Building FreeBSD port $port..."
    
    if ! check_port "$port"; then
        error "Port check failed for $port"
        return 1
    fi
    
    # Check cache
    if [ -f "$cache_file" ]; then
        local cache_mtime=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
        local source_mtime=$(find "$port_dir" -name "Makefile" -o -name "files/*" | head -1 | xargs stat -f %m 2>/dev/null || echo 1)
        
        if [ "$cache_mtime" -gt "$source_mtime" ]; then
            log "Using cached $port"
            cp "$cache_file" "$BUILD_ROOT/"
            return 0
        fi
    fi
    
    # Build with retries
    while [ $retries -lt $MAX_RETRIES ]; do
        cd "$port_dir"
        if make clean package >"$log_file" 2>&1; then
            success "$port built successfully"
            local pkg_file
            pkg_file=$(ls -t work/stage/*.pkg | head -1)
            if [ -f "$pkg_file" ]; then
                cp "$pkg_file" "$cache_file"
            fi
            return 0
        else
            ((retries++))
            warn "$port build failed (attempt $retries), check $log_file"
            if [ $retries -lt $MAX_RETRIES ]; then
                sleep 5
            fi
        fi
    done
    
    error "$port failed after $MAX_RETRIES attempts"
    return 1
}

# Parallel build for FreeBSD ports
build_parallel() {
    local build_order=("$@")
    local pids=()
    local failed=()
    
    for port in "${build_order[@]}"; do
        build_port "$port" &
        pids+=($!)
    done
    
    for i in "${!pids[@]}"; do
        if ! wait "${pids[$i]}"; then
            failed+=("${build_order[$i]}")
        fi
    done
    
    if [ ${#failed[@]} -gt 0 ]; then
        error "Failed ports: ${failed[*]}"
        return 1
    fi
    
    return 0
}

# Main
main() {
    local target_ports=("${!PORTS[@]}")
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --port|-p)
                target_ports=("$2")
                shift 2
                ;;
            --clean)
                log "Cleaning FreeBSD build artifacts..."
                rm -rf "$CACHE_DIR" "$LOG_DIR"
                exit 0
                ;;
            --help|-h)
                echo "Usage: $0 [options] [ports...]"
                echo "Options:"
                echo "  -p, --port PORT    Build only specific port"
                echo "  --clean             Clean build cache"
                echo "  --freebsd           Use FreeBSD ports framework (default)"
                exit 0
                ;;
            *)
                target_ports+=("$1")
                shift
                ;;
        esac
    done
    
    mkdir -p "$CACHE_DIR" "$LOG_DIR"
    
    log "Resolving FreeBSD port dependencies..."
    local build_order
    if ! build_order=$(get_build_order "${target_ports[@]}"); then
        exit 1
    fi
    
    log "FreeBSD build order: $build_order"
    
    if build_parallel $build_order; then
        success "All FreeBSD ports built successfully"
    else
        exit 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi