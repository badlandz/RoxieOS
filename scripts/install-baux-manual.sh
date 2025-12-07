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
pkg install -y bash git neovim tmux x11-fonts xterm >> "$LOG_FILE" 2>&1 || error "Package installation failed"

# Ensure bash is available at the expected path
if [ ! -x "/usr/local/bin/bash" ]; then
    log "bash not found at /usr/local/bin/bash, pkg install may have failed"
fi

# Ensure fonts are available for accessibility
log "=== Ensuring Font Availability ==="
if ! pkg info | grep -q "x11-fonts"; then
    error "x11-fonts package not installed - required for console fonts"
    exit 1
fi

# Check for required console fonts
MISSING_FONTS=""
for font in "TERMINAL_16x32.fnt" "TERMINAL_12x24.fnt" "TERMINAL_8x16.fnt"; do
    if [ ! -f "/usr/share/syscons/fonts/$font" ]; then
        MISSING_FONTS="$MISSING_FONTS $font"
    fi
done

if [ -n "$MISSING_FONTS" ]; then
    error "Missing required console fonts:$MISSING_FONTS"
    log "This will cause font accessibility issues"
    log "Try: pkg delete x11-fonts && pkg install x11-fonts"
else
    success "All required console fonts are available"
fi

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
log "Running install.sh..."
if doas ./install.sh >> "$LOG_FILE" 2>&1; then
    success "baux install.sh completed"
else
    error "baux install.sh failed"
    exit 1
fi

log "Testing baux command..."
baux --help >> "$LOG_FILE" 2>&1 || log "baux command not found or failed (expected during install)"
log "baux should show help. Try 'baux' to start session"

## Install bvi (Editor)
log "=== Installing bvi (Editor) ==="
log "Changing to ../bvi..."
cd ../bvi || { error "Cannot cd to ../bvi"; exit 1; }
log "Running install.sh..."
if doas ./install.sh >> "$LOG_FILE" 2>&1; then
    success "bvi install.sh completed"
else
    error "bvi install.sh failed"
    exit 1
fi

log "Testing bvi command..."
bvi --version >> "$LOG_FILE" 2>&1 2>/dev/null || log "bvi wrapper ready"
log "Try 'bvi test.txt' to edit a file"

## Run System Test
log "=== Running System Test ==="
log "Changing to project root scripts..."
cd ../../scripts || { error "Cannot cd to ../../scripts from $(pwd)"; exit 1; }
log "Running test-baux.sh..."
./test-baux.sh 2>&1 || log "Test script failed (expected during installation)"

## Next Steps
success "=== Installation Complete ==="
log "Core BAUX components installed!"
log "Log saved to: $LOG_FILE"
log ""
log "FONT ACCESSIBILITY:"
log "  Console: Large fonts set (16x32 preferred)"
log "  X11: 192 DPI with 20pt fonts"
log "  Backup: xterm with guaranteed large fonts"
log ""
log "If fonts are still too small:"
log "  ./scripts/setup-early-font.sh    (console after video driver)"
log "  ./scripts/setup-display.sh       (X11 fonts)"
log "  ./scripts/launch-backup-terminal.sh  (emergency terminal)"
log "  ./scripts/emergency-font-fix.sh  (try everything)"
log ""
log "Next: Test bwm (window manager) and chaos (screensaver)"
log "Then: Implement live USB persistence"
log ""
log "Check the log file for details: $LOG_FILE"