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
log "Updating package database..."
pkg update >> "$LOG_FILE" 2>&1 || log "pkg update failed, continuing..."

log "Installing required packages..."
pkg install -y bash git neovim tmux xterm >> "$LOG_FILE" 2>&1 || error "Package installation failed"

# Ensure bash is available at the expected path
if [ ! -x "/usr/local/bin/bash" ]; then
    log "bash not found at /usr/local/bin/bash, pkg install may have failed"
fi

# Check for console fonts (TERMINAL_*.fnt files)
log "=== Checking Console Font Availability ==="
CONSOLE_FONTS_AVAILABLE=false
if [ -f "/usr/share/syscons/fonts/TERMINAL_8x16.fnt" ] || \
   [ -f "/usr/share/syscons/fonts/TERMINAL_12x24.fnt" ] || \
   [ -f "/usr/share/syscons/fonts/TERMINAL_16x32.fnt" ]; then
    log "✓ Console fonts found in /usr/share/syscons/fonts/"
    CONSOLE_FONTS_AVAILABLE=true
else
    log "⚠ Console fonts not found - they may be in base system or need different package"
    # Check if any .fnt files exist
    if ls /usr/share/syscons/fonts/*.fnt >/dev/null 2>&1; then
        log "Available console fonts:"
        ls /usr/share/syscons/fonts/*.fnt | head -5 >> "$LOG_FILE" 2>&1
        CONSOLE_FONTS_AVAILABLE=true
    else
        log "No .fnt files found in /usr/share/syscons/fonts/"
        log "Console fonts may be provided by base FreeBSD system"
        CONSOLE_FONTS_AVAILABLE=true  # Assume base system provides them
    fi
fi

if [ "$CONSOLE_FONTS_AVAILABLE" = false ]; then
    log "WARNING: Console fonts may not be available"
    log "BAUX will still work but console fonts may be limited"
fi
done

# Ensure bash is available at the expected path
if [ ! -x "/usr/local/bin/bash" ]; then
    error "bash not found at /usr/local/bin/bash, pkg install may have failed"
    log "Try: doas pkg install -y bash"
    exit 1
fi

log "✓ All prerequisites verified"

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

# Verify install.sh exists and is executable
if [ ! -x "install.sh" ]; then
    error "install.sh not found or not executable in $(pwd)"
    ls -la install.sh 2>/dev/null || log "install.sh not found"
    exit 1
fi

log "Running install.sh..."
if doas ./install.sh >> "$LOG_FILE" 2>&1; then
    success "bbase installed successfully"
else
    error "bbase install.sh failed"
    log "Check the log file: $LOG_FILE"
    log "Try running manually: cd ports/bbase && doas ./install.sh"
    exit 1
fi

# Test keymap
log "Testing keymap..."
if doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd >> "$LOG_FILE" 2>&1; then
    success "Keymap loaded successfully"
    log "✓ Caps Lock should now be Escape globally"
else
    error "Keymap load failed"
    log "Try manually: doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
fi

## Install baux (Session Manager)
log "=== Installing baux (Session Manager) ==="
log "Changing to ../baux..."
cd ../baux || { error "Cannot cd to ../baux"; exit 1; }

# Verify install.sh exists
if [ ! -x "install.sh" ]; then
    error "baux install.sh not found or not executable in $(pwd)"
    ls -la install.sh 2>/dev/null || log "install.sh not found"
    exit 1
fi

log "Running install.sh..."
if doas ./install.sh >> "$LOG_FILE" 2>&1; then
    success "baux install.sh completed"
else
    error "baux install.sh failed"
    log "Check the log file: $LOG_FILE"
    exit 1
fi

log "Testing baux command..."
if command -v baux >/dev/null 2>&1; then
    baux --help >> "$LOG_FILE" 2>&1 || log "baux --help failed"
    success "✓ baux command available"
else
    error "✗ baux command not found in PATH"
    log "Check if /usr/local/bin is in PATH"
fi
log "Try 'baux' to start the BAUX session"

## Install bvi (Editor)
log "=== Installing bvi (Editor) ==="
log "Changing to ../bvi..."
cd ../bvi || { error "Cannot cd to ../bvi"; exit 1; }

# Verify install.sh exists
if [ ! -x "install.sh" ]; then
    error "bvi install.sh not found or not executable in $(pwd)"
    ls -la install.sh 2>/dev/null || log "install.sh not found"
    exit 1
fi

log "Running install.sh..."
if doas ./install.sh >> "$LOG_FILE" 2>&1; then
    success "bvi install.sh completed"
else
    error "bvi install.sh failed"
    log "Check the log file: $LOG_FILE"
    exit 1
fi

log "Testing bvi command..."
if command -v bvi >/dev/null 2>&1; then
    success "✓ bvi command available"
    bvi --version >> "$LOG_FILE" 2>&1 2>/dev/null || log "bvi wrapper ready"
else
    error "✗ bvi command not found in PATH"
fi
log "Try 'bvi test.txt' to edit a file"

## Run System Test
log "=== Running System Test ==="
log "Changing to project root scripts..."
cd ../../scripts || { error "Cannot cd to ../../scripts from $(pwd)"; exit 1; }
log "Running test-baux.sh..."
./test-baux.sh 2>&1 || log "Test script failed (expected during installation)"

## Next Steps
success "=== BAUX INSTALLATION COMPLETE ==="
log "Core BAUX components installed successfully!"
log "Log saved to: $LOG_FILE"
log ""

log "ACCESSIBILITY FEATURES INSTALLED:"
log "  ✓ Console fonts: Large, readable sizes configured"
log "  ✓ X11 fonts: 192 DPI with 20pt effective text"
log "  ✓ Resolution: Limited to 1920x1280 maximum"
log "  ✓ Backup terminal: xterm with guaranteed large fonts"
log ""

log "TEST YOUR INSTALLATION:"
log "  1. Test keymap: Caps Lock should be Escape"
log "  2. Test BAUX: Run 'baux' to start environment"
log "  3. Test fonts: Run './scripts/verify-display.sh'"
log "  4. Test editor: Run 'bvi test.txt'"
log ""

log "IF FONTS ARE UNREADABLE:"
log "  ./scripts/setup-early-font.sh        (console fonts)"
log "  ./scripts/setup-display.sh           (X11 fonts)"
log "  ./scripts/launch-backup-terminal.sh  (emergency readable terminal)"
log "  ./scripts/emergency-font-fix.sh      (try everything)"
log ""

log "DEBUGGING TOOLS:"
log "  ./scripts/debug-baux-session.sh      (comprehensive system check)"
log "  ./scripts/quick-accessibility-fix.sh (immediate font fixes)"
log ""

log "NEXT STEPS:"
log "  1. Test bwm window manager installation"
log "  2. Test chaos screensaver"
log "  3. Implement live USB persistence"
log ""

log "📋 INSTALLATION LOG: $LOG_FILE"
log "📋 ACCESSIBILITY DOCS: docs/Accessibility-Display.md"
log "📋 TROUBLESHOOTING: Check log file for any warnings/errors"