#!/usr/local/bin/bash
# BAUX Manual Installation Guide for X300 ThinkPad
# Run these commands on your FreeBSD X300 system
# Creates comprehensive installation log for debugging

set -e  # Exit on any error

# Configuration
LOG_FILE="${1:-baux-manual-install-$(date +%Y%m%d-%H%M%S).log}"

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

log "=== BAUX Manual Installation Started ==="
log "Current directory: $(pwd)"
log "User: $(whoami)"
log "Log file: $LOG_FILE"

## Prerequisites
log "=== Installing Prerequisites ==="
pkg update >> "$LOG_FILE" 2>&1 || log "pkg update failed, continuing..."
pkg install -y bash git neovim tmux >> "$LOG_FILE" 2>&1 || error "Package installation failed"

## Install bbase (Foundation)
log "=== Installing bbase (Foundation) ==="
log "Changing to ports/bbase..."
cd ports/bbase || { error "Cannot cd to ports/bbase from $(pwd)"; exit 1; }
log "Running install.sh..."
if doas ./install.sh >> "$LOG_FILE" 2>&1; then
    success "bbase installed successfully"
else
    error "bbase install.sh failed"
    log "Check the log file for details: $LOG_FILE"
    exit 1
fi

# Test keymap
log "Testing keymap..."
if doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd >> "$LOG_FILE" 2>&1; then
    success "Keymap loaded successfully"
else
    error "Keymap load failed"
fi
log "Caps Lock should now be Escape. Test it!"

## Install baux (Session Manager)
log "=== Installing baux (Session Manager) ==="
log "Changing to ../baux..."
cd ../baux || { error "Cannot cd to ../baux"; exit 1; }
echo "Running install.sh..."
doas ./install.sh || { echo "ERROR: baux install.sh failed"; exit 1; }

# Test session manager
echo "Testing baux command..."
baux --help || echo "baux command not found or failed"
echo "baux should show help. Try 'baux' to start session"

## Install bvi (Editor)
echo "=== Installing bvi (Editor) ==="
echo "Changing to ../bvi..."
cd ../bvi || { echo "ERROR: Cannot cd to ../bvi"; exit 1; }
echo "Running install.sh..."
doas ./install.sh || { echo "ERROR: bvi install.sh failed"; exit 1; }

# Test editor
echo "Testing bvi command..."
bvi --version 2>/dev/null || echo "bvi wrapper ready"
echo "Try 'bvi test.txt' to edit a file"

## Run System Test
echo "=== Running System Test ==="
echo "Changing to ../scripts..."
cd ../scripts || { echo "ERROR: Cannot cd to ../scripts"; exit 1; }
echo "Running test-baux.sh..."
./test-baux.sh

## Next Steps
echo "=== Installation Complete ==="
echo "Core BAUX components installed!"
echo "Next: Test bwm (window manager) and chaos (screensaver)"
echo "Then: Implement live USB persistence"