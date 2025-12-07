#!/usr/local/bin/bash
# BAUX Unified Installation Script with Logging
# Creates comprehensive installation log for debugging

set -e  # Exit on any error

# Configuration
LOG_FILE="${1:-baux-install-$(date +%Y%m%d-%H%M%S).log}"
BAUX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Logging functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $*" | tee -a "$LOG_FILE"
}

error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $*" | tee -a "$LOG_FILE" >&2
}

success() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [SUCCESS] $*" | tee -a "$LOG_FILE"
}

# System information logging
log_system_info() {
    log "=== System Information ==="
    log "Date: $(date)"
    log "Hostname: $(hostname)"
    log "User: $(whoami)"
    log "UID: $(id -u)"
    log "GID: $(id -g)"
    log "FreeBSD Version: $(freebsd-version 2>/dev/null || uname -rs)"
    log "Current Directory: $(pwd)"
    log "BAUX Root: $BAUX_ROOT"
    log "Log File: $LOG_FILE"
    log "PATH: $PATH"
    log ""
}

# Dependency checking
check_dependencies() {
    log "=== Checking Dependencies ==="

    # Check bash
    if command -v bash >/dev/null 2>&1; then
        log "✅ bash found: $(bash --version | head -1)"
    else
        error "❌ bash not found"
        return 1
    fi

    # Check doas or sudo
    if command -v doas >/dev/null 2>&1; then
        if doas whoami >/dev/null 2>&1; then
            log "✅ doas configured and working"
        else
            error "❌ doas not configured properly"
            log "   Run: echo 'permit nopass :wheel' >> /usr/local/etc/doas.conf"
            return 1
        fi
    elif command -v sudo >/dev/null 2>&1; then
        if sudo -n whoami >/dev/null 2>&1; then
            log "✅ sudo configured and working"
            # Set doas to sudo for compatibility
            alias doas=sudo
        else
            error "❌ sudo not configured properly"
            log "   Configure sudo or install doas"
            return 1
        fi
    else
        error "❌ Neither doas nor sudo found"
        return 1
    fi

    # Check required packages
    local required_packages=("neovim" "tmux")
    for pkg in "${required_packages[@]}"; do
        if command -v "$pkg" >/dev/null 2>&1; then
            log "✅ $pkg available: $("$pkg" --version 2>/dev/null | head -1 || echo "version check failed")"
        else
            error "❌ $pkg not found"
            log "   Install with: pkg install $pkg (FreeBSD) or apt install $pkg (Debian/Ubuntu)"
            return 1
        fi
    done

    log ""
}

# Repository structure check
check_repository() {
    log "=== Checking Repository Structure ==="

    local required_dirs=("ports/bbase" "ports/baux" "ports/bvi" "scripts")
    local required_files=("ports/bbase/baux.kbd" "ports/baux/core/baux" "ports/baux/core/tmux/baux.conf" "ports/bvi/src/bvi.sh")

    for dir in "${required_dirs[@]}"; do
        if [ -d "$BAUX_ROOT/$dir" ]; then
            log "✅ Directory exists: $dir"
        else
            error "❌ Directory missing: $dir"
            return 1
        fi
    done

    for file in "${required_files[@]}"; do
        if [ -f "$BAUX_ROOT/$file" ]; then
            log "✅ File exists: $file"
        else
            error "❌ File missing: $file"
            return 1
        fi
    done

    log ""
}

# Install component with logging
install_component() {
    local component="$1"
    local install_dir="$2"

    log "=== Installing $component ==="
    log "Component: $component"
    log "Directory: $install_dir"
    log "Working Directory: $(pwd)"

    if [ ! -d "$install_dir" ]; then
        error "❌ Install directory does not exist: $install_dir"
        return 1
    fi

    cd "$install_dir" || {
        error "❌ Cannot change to directory: $install_dir"
        return 1
    }

    log "Running install.sh..."
    if doas ./install.sh >> "$LOG_FILE" 2>&1; then
        success "✅ $component installed successfully"
        return 0
    else
        error "❌ $component installation failed"
        log "   Check install.sh output above in log file"
        return 1
    fi
}

# Test installation
test_installation() {
    log "=== Testing Installation ==="

    # Test bbase
    if [ -f "/usr/share/syscons/keymaps/baux.kbd" ]; then
        log "✅ bbase keymap installed"
    else
        error "❌ bbase keymap not found"
    fi

    # Test baux
    if [ -x "/usr/local/bin/baux" ]; then
        log "✅ baux script installed"
    else
        error "❌ baux script not found"
    fi

    if [ -f "/usr/local/share/tmux/baux.conf" ]; then
        log "✅ baux tmux config installed"
    else
        error "❌ baux tmux config not found"
    fi

    # Test bvi
    if [ -x "/usr/local/bin/bvi" ]; then
        log "✅ bvi script installed"
    else
        error "❌ bvi script not found"
    fi

    if [ -f "/usr/local/etc/bvi/init.vim" ]; then
        log "✅ bvi neovim config installed"
    else
        error "❌ bvi neovim config not found"
    fi

    log ""
}

# Main installation
main() {
    log "=== BAUX Unified Installation Started ==="
    log "Log file: $LOG_FILE"
    log ""

    # Initial setup
    log_system_info

    # Dependency checks
    if ! check_dependencies; then
        error "❌ Dependency check failed. Fix issues and try again."
        exit 1
    fi

    # Repository checks
    if ! check_repository; then
        error "❌ Repository check failed. Ensure all files are present."
        exit 1
    fi

    # Install components
    cd "$BAUX_ROOT" || {
        error "❌ Cannot change to BAUX root: $BAUX_ROOT"
        exit 1
    }

    local install_errors=0

    if ! install_component "bbase" "ports/bbase"; then
        ((install_errors++))
    fi

    if ! install_component "baux" "ports/baux"; then
        ((install_errors++))
    fi

    if ! install_component "bvi" "ports/bvi"; then
        ((install_errors++))
    fi

    # Test installation
    test_installation

    # Final report
    log "=== Installation Complete ==="
    if [ $install_errors -eq 0 ]; then
        success "✅ All components installed successfully!"
        log "Log saved to: $LOG_FILE"
        log ""
        log "Next steps:"
        log "1. Test keymap: doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
        log "2. Test baux: baux --help"
        log "3. Test bvi: bvi test.txt"
        log "4. Run full test: ./scripts/test-baux.sh"
    else
        error "❌ $install_errors component(s) failed to install"
        log "Check the log file for details: $LOG_FILE"
        exit 1
    fi
}

# Run main function
main "$@"