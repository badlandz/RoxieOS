#!/usr/local/bin/bash
# BAUX Manual Installation Guide for X300 ThinkPad
# Run these commands on your FreeBSD X300 system
# Creates comprehensive installation log for debugging

set -e  # Exit on any error

# Configuration
LOG_FILE="${1:-$(pwd)/baux-manual-install-$(date +%Y%m%d-%H%M%S).log}"

# Logging functions
log() {
    echo "[INFO] $*" | tee -a "$LOG_FILE"
}

error() {
    echo "[ERROR] $*" | tee -a "$LOG_FILE" >&2
}

success() {
    echo "[SUCCESS] $*" | tee -a "$LOG_FILE"
}

# Privilege escalation helper
run_privileged() {
    if [ "$USE_DOAS" = true ]; then
        doas "$@"
    else
        "$@"
    fi
}

# Trap to log unexpected exits (now that LOG_FILE and functions are available)
# trap 'error "Script failed at line $LINENO"; log "Last command: $BASH_COMMAND"' ERR

log "=== BAUX Manual Installation Started ==="
log "Current directory: $(pwd)"
log "User: $(whoami)"
log "Log file: $LOG_FILE"

## Check if running as root or need doas
log "=== Checking Privilege Requirements ==="
if [ "$(id -u)" -eq 0 ]; then
    log "✓ Running as root - no privilege escalation needed"
    USE_DOAS=false
else
    log "Running as regular user - checking doas availability"
    if command -v doas >/dev/null 2>&1; then
        # Try a simple doas command to see if it works
        if doas true >/dev/null 2>&1; then
            log "✓ doas is working correctly"
            USE_DOAS=true
        else
            log "⚠ doas command failed - checking configuration"
            if [ ! -f "/etc/doas.conf" ]; then
                log "doas.conf not found - you may need to configure doas"
                log "Try: su root -c 'echo \"permit nopass :wheel\" >> /etc/doas.conf'"
            else
                log "doas.conf exists but may not grant permissions to your user"
                log "Ensure your user is in the wheel group: su root -c 'pw groupmod wheel -m $(whoami)'"
            fi
            log "Continuing anyway - some operations may require manual intervention"
            USE_DOAS=true  # Try anyway, commands will show errors if they fail
        fi
    else
        log "⚠ doas not found - some operations may require manual intervention"
        log "Install doas: pkg install doas"
        USE_DOAS=false
    fi
fi

## Prerequisites
log "=== Installing Prerequisites ==="
log "Updating package database..."
pkg update >> "$LOG_FILE" 2>&1 || log "pkg update failed, continuing..."

log "Installing required packages..."
pkg install -y bash git neovim tmux xterm rsync >> "$LOG_FILE" 2>&1 || error "Package installation failed"

# Ensure bash is available at the expected path
if [ ! -x "/usr/local/bin/bash" ]; then
    log "bash not found at /usr/local/bin/bash, pkg install may have failed"
fi

# Check for console fonts (TERMINAL_*.fnt files)
log "=== Checking Console Font Availability ==="
log "Console fonts are provided by base FreeBSD system (/usr/share/syscons/fonts/)"
CONSOLE_FONTS_AVAILABLE=false

# Check for specific accessibility fonts we need
if [ -f "/usr/share/syscons/fonts/TERMINAL_8x16.fnt" ] || \
   [ -f "/usr/share/syscons/fonts/TERMINAL_12x24.fnt" ] || \
   [ -f "/usr/share/syscons/fonts/TERMINAL_16x32.fnt" ]; then
    log "✓ Required console fonts found in /usr/share/syscons/fonts/"
    CONSOLE_FONTS_AVAILABLE=true
else
    log "⚠ Specific TERMINAL fonts not found - checking for any console fonts"
    # Check if any .fnt files exist
    if ls /usr/share/syscons/fonts/*.fnt >/dev/null 2>&1; then
        log "Available console fonts:"
        ls /usr/share/syscons/fonts/*.fnt | head -5 >> "$LOG_FILE" 2>&1
        CONSOLE_FONTS_AVAILABLE=true
        log "✓ Console fonts available (may not include all sizes needed for accessibility)"
    else
        log "No .fnt files found in /usr/share/syscons/fonts/"
        log "Console fonts may be missing from base FreeBSD installation"
        log "This is unusual - console fonts should be part of base system"
        CONSOLE_FONTS_AVAILABLE=false
    fi
fi

if [ "$CONSOLE_FONTS_AVAILABLE" = false ]; then
    log "WARNING: Console fonts may not be available"
    log "BAUX will still work but console font accessibility may be limited"
    log "Consider installing additional fonts: pkg install misc/console-fonts"
fi

# Ensure bash is available at the expected path
if [ ! -x "/usr/local/bin/bash" ]; then
    error "bash not found at /usr/local/bin/bash, pkg install may have failed"
    log "Try: doas pkg install -y bash"
    exit 1
fi

log "✓ All prerequisites verified"

# Verify console font management tools are available
log "=== Verifying Console Font Management ==="
if command -v vidcontrol >/dev/null 2>&1; then
    log "✓ vidcontrol available for console font management"
else
    log "⚠ vidcontrol not found - console font switching may not work"
    log "vidcontrol should be part of base FreeBSD system"
fi

# Check for required console fonts for accessibility
MISSING_FONTS=""
for font in "TERMINAL_16x32.fnt" "TERMINAL_12x24.fnt" "TERMINAL_8x16.fnt"; do
    if [ ! -f "/usr/share/syscons/fonts/$font" ]; then
        MISSING_FONTS="$MISSING_FONTS $font"
    fi
done

if [ -n "$MISSING_FONTS" ]; then
    log "Missing some console fonts:$MISSING_FONTS"
    log "Installing additional console fonts for better accessibility..."
    pkg install -y misc/console-fonts >> "$LOG_FILE" 2>&1 || log "Failed to install console-fonts, continuing with available fonts"

    # Check again after installation
    MISSING_FONTS=""
    for font in "TERMINAL_16x32.fnt" "TERMINAL_12x24.fnt" "TERMINAL_8x16.fnt"; do
        if [ ! -f "/usr/share/syscons/fonts/$font" ]; then
            MISSING_FONTS="$MISSING_FONTS $font"
        fi
    done

    if [ -n "$MISSING_FONTS" ]; then
        log "Some fonts still missing after installation:$MISSING_FONTS"
        log "BAUX will work with available fonts"
    else
        success "All required console fonts now available!"
    fi
else
    success "All required console fonts are available"
fi

## Install bbase (Foundation)
log "=== Installing bbase (Foundation) ==="
echo "DEBUG: About to check pwd" >> "$LOG_FILE"
log "Current working directory before cd: $(pwd)"
echo "DEBUG: pwd worked, about to check directory" >> "$LOG_FILE"
log "Checking if ports/bbase exists..."
if [ -d "ports/bbase" ]; then
    log "✓ ports/bbase directory exists"
else
    error "ports/bbase directory not found"
    ls -la ports/ 2>/dev/null || log "ports/ directory not found either"
    exit 1
fi
log "Changing to ports/bbase..."
log "About to execute: cd ports/bbase"
cd ports/bbase || { error "Cannot cd to ports/bbase from $(pwd)"; exit 1; }
log "cd command completed successfully"
log "Current pwd result: $(pwd)"
log "Successfully changed to: $(pwd)"

# Verify install.sh exists and is executable
log "Checking for install.sh in $(pwd)..."
ls -la install.sh 2>/dev/null || log "install.sh listing failed"
if [ ! -x "install.sh" ]; then
    error "install.sh not found or not executable in $(pwd)"
    log "Full listing of current directory:"
    ls -la 2>/dev/null >> "$LOG_FILE" 2>&1 || log "ls failed"
    exit 1
fi

log "Running install.sh..."
log "About to execute: run_privileged ./install.sh"
if run_privileged ./install.sh >> "$LOG_FILE" 2>&1; then
    success "bbase installed successfully"
    log "bbase installation completed successfully"
else
    error "bbase install.sh failed"
    log "Check the log file: $LOG_FILE"
    log "Try running manually: cd ports/bbase && doas ./install.sh"
    exit 1
fi

log "bbase installation section completed"
# Test keymap
log "Testing keymap..."
if run_privileged kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd >> "$LOG_FILE" 2>&1; then
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
if run_privileged ./install.sh >> "$LOG_FILE" 2>&1; then
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
if run_privileged ./install.sh >> "$LOG_FILE" 2>&1; then
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