#!/usr/local/bin/bash
# BAUX Debug Script - Comprehensive logging for troubleshooting
# Logs system state, display settings, and BAUX functionality

set -euo pipefail

LOG_FILE="${1:-baux-debug-$(date +%Y%m%d-%H%M%S).log}"

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

warn() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [WARN] $*" | tee -a "$LOG_FILE"
}

log "=== BAUX DEBUG SESSION STARTED ==="
log "Log file: $LOG_FILE"
log "System: $(uname -a)"
log "User: $(whoami)"
log "Date: $(date)"

# System Information
log ""
log "=== SYSTEM INFORMATION ==="
log "Hostname: $(hostname)"
log "FreeBSD Version: $(freebsd-version 2>/dev/null || uname -rs)"
log "Bash Path: $(which bash 2>/dev/null || echo 'bash not found')"
log "Hardware: $(sysctl -n hw.model 2>/dev/null || echo 'unknown')"
log "Memory: $(sysctl -n hw.physmem 2>/dev/null || echo 'unknown')"
log "CPU: $(sysctl -n hw.ncpu 2>/dev/null || echo 'unknown') cores"

# Environment
log ""
log "=== ENVIRONMENT ==="
log "PWD: $(pwd)"
log "PATH: $PATH"
log "DISPLAY: ${DISPLAY:-not set}"
log "TERM: ${TERM:-not set}"
log "TMUX: ${TMUX:-not set}"
log "BAUX_HOME: ${BAUX_HOME:-not set}"

# BAUX Installation Check
log ""
log "=== BAUX INSTALLATION CHECK ==="
if command -v baux >/dev/null 2>&1; then
    success "baux command found: $(which baux)"
    baux --version >> "$LOG_FILE" 2>&1 || log "baux --version failed"
else
    error "baux command not found"
fi

# TMUX Check
if command -v tmux >/dev/null 2>&1; then
    log "TMUX version: $(tmux -V)"
    if tmux has-session 2>/dev/null; then
        log "TMUX sessions active: $(tmux list-sessions | wc -l)"
    else
        log "No TMUX sessions active"
    fi
else
    error "TMUX not found"
fi

# Neovim Check
if command -v nvim >/dev/null 2>&1; then
    log "Neovim version: $(nvim --version | head -1)"
else
    error "Neovim not found"
fi

# Display Configuration
log ""
log "=== DISPLAY CONFIGURATION ==="

# Console display
if command -v vidcontrol >/dev/null 2>&1; then
    CONSOLE_FONT=$(doas vidcontrol -i active 2>/dev/null | head -1 || echo 'unknown')
    log "Console font: $CONSOLE_FONT"

    # Check if font is accessibility-compliant
    if [[ "$CONSOLE_FONT" == *"16x32"* ]]; then
        success "Console font is excellent (16x32)"
    elif [[ "$CONSOLE_FONT" == *"12x24"* ]]; then
        success "Console font is very good (12x24)"
    elif [[ "$CONSOLE_FONT" == *"8x16"* ]]; then
        warn "Console font acceptable but could be larger (8x16)"
    else
        error "Console font may be too small for accessibility"
    fi

    # Show available fonts
    log "Available console fonts:"
    AVAILABLE_FONTS=$(doas ls -1 /usr/share/syscons/fonts/ 2>/dev/null | grep '\.fnt$' | sort)
    echo "$AVAILABLE_FONTS" | head -5 >> "$LOG_FILE" 2>&1

    # Check if required fonts are missing
    MISSING_FONTS=""
    for font in "TERMINAL_16x32.fnt" "TERMINAL_12x24.fnt" "TERMINAL_8x16.fnt"; do
        if ! echo "$AVAILABLE_FONTS" | grep -q "$font"; then
            MISSING_FONTS="$MISSING_FONTS $font"
        fi
    done

    if [ -n "$MISSING_FONTS" ]; then
        warn "Missing accessibility fonts:$MISSING_FONTS"
        log "Install with: pkg install x11-fonts"
    fi
else
    log "vidcontrol not available"
fi

# X11 display
if [ -n "${DISPLAY:-}" ]; then
    log "X11 Display: $DISPLAY"

    if command -v xdpyinfo >/dev/null 2>&1; then
        RESOLUTION=$(xdpyinfo 2>/dev/null | grep "dimensions:" | awk '{print $2}' || echo "unknown")
        log "X11 Resolution: $RESOLUTION"
    fi

    if command -v xrdb >/dev/null 2>&1; then
        log "X11 Resources (font settings):"
        xrdb -query | grep -E "(Xft|dpi)" >> "$LOG_FILE" 2>&1 || log "No Xft settings found"

        # Check DPI specifically
        X_DPI=$(xrdb -query | grep "Xft.dpi" | awk '{print $2}' || echo "not set")
        log "X11 DPI setting: $X_DPI"

        if [ "$X_DPI" -ge 192 ] 2>/dev/null; then
            success "X11 DPI is excellent for accessibility ($X_DPI)"
        elif [ "$X_DPI" -ge 120 ] 2>/dev/null; then
            warn "X11 DPI acceptable but could be higher ($X_DPI)"
        else
            error "X11 DPI too low for accessibility ($X_DPI)"
        fi
    fi

    if command -v xrandr >/dev/null 2>&1; then
        log "X11 available resolutions:"
        xrandr | grep -E "[0-9]+x[0-9]+" >> "$LOG_FILE" 2>&1 || log "xrandr failed"
    fi
else
    log "No X11 display detected (console mode)"
fi

# Keymap Check
log ""
log "=== KEYMAP CONFIGURATION ==="
if command -v kbdcontrol >/dev/null 2>&1; then
    CURRENT_KEYMAP=$(doas kbdcontrol -d 2>/dev/null | head -1 || echo "unknown")
    log "Current keymap: $CURRENT_KEYMAP"

    if [[ "$CURRENT_KEYMAP" == *"baux"* ]]; then
        success "BAUX keymap is active"
    else
        warn "BAUX keymap not active"
        log "Available keymaps:"
        doas ls -la /usr/share/syscons/keymaps/ | grep baux >> "$LOG_FILE" 2>&1 || log "No baux keymap found"
        log "To fix: doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
    fi
else
    log "kbdcontrol not available"
fi

# rc.conf check
if [ -f "/etc/rc.conf" ]; then
    KEYMAP_SETTING=$(grep "keymap" /etc/rc.conf || echo "not set")
    log "rc.conf keymap setting: $KEYMAP_SETTING"
fi

# Multiple keymap sources check
log "Keymap sources:"
log "- rc.conf: $(grep -s "keymap" /etc/rc.conf 2>/dev/null || echo "not set")"
log "- loader.conf: $(grep -s "keymap" /boot/loader.conf 2>/dev/null || echo "not set")"
log "- Current active: $CURRENT_KEYMAP"

# BAUX Config Files
log ""
log "=== BAUX CONFIGURATION FILES ==="
CONFIG_FILES=(
    "/usr/local/share/tmux/baux.conf"
    "/usr/local/share/bvi/lite/lua/config/options.lua"
    "/usr/local/share/bvi/dev/lua/config/options.lua"
    "/usr/share/syscons/keymaps/baux.kbd"
)

for config in "${CONFIG_FILES[@]}"; do
    if [ -f "$config" ]; then
        log "✓ Found: $config"
    else
        warn "✗ Missing: $config"
    fi
done

# Font Files Check
log ""
log "=== FONT AVAILABILITY ==="
FONT_LOCATIONS=(
    "/usr/share/syscons/fonts/TERMINAL_8x16.fnt"
    "/usr/share/syscons/fonts/TERMINAL_12x24.fnt"
    "/usr/share/fonts"
)

for font_loc in "${FONT_LOCATIONS[@]}"; do
    if [ -e "$font_loc" ]; then
        log "✓ Font location exists: $font_loc"
        if [ -d "$font_loc" ]; then
            FONT_COUNT=$(find "$font_loc" -name "*.fnt" 2>/dev/null | wc -l)
            log "  Font files: $FONT_COUNT"
        fi
    else
        warn "✗ Font location missing: $font_loc"
    fi
done

# Performance Test
log ""
log "=== PERFORMANCE TEST ==="
if command -v nvim >/dev/null 2>&1; then
    START_TIME=$(date +%s%N)
    timeout 10 nvim --headless -c "quit" >/dev/null 2>&1
    END_TIME=$(date +%s%N)
    STARTUP_MS=$(( (END_TIME - START_TIME) / 1000000 ))
    log "Neovim startup time: ${STARTUP_MS}ms"
fi

# Recommendations
log ""
log "=== RECOMMENDATIONS ==="

if ! command -v baux >/dev/null 2>&1; then
    error "CRITICAL: baux command not found - reinstall BAUX"
elif ! tmux -f /usr/local/share/tmux/baux.conf new-session -A -s test-session 2>/dev/null; then
    error "CRITICAL: TMUX config not loading properly"
else
    success "BAUX appears to be working"
fi

if [ -z "${DISPLAY:-}" ]; then
    warn "Console mode detected - X11 display settings won't apply"
    log "For console accessibility: ./scripts/setup-early-font.sh"
fi

if [[ "$CURRENT_KEYMAP" != *"baux"* ]]; then
    error "BAUX keymap not active - Caps Lock won't work as Escape"
    log "Fix: doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
    log "Make permanent: echo 'keymap=\"baux\"' >> /etc/rc.conf"
fi

# Font accessibility check
if [[ "$CONSOLE_FONT" == *"8x16"* ]] || [[ "$CONSOLE_FONT" == "unknown" ]]; then
    error "Console font too small for accessibility"
    log "Fix: ./scripts/setup-early-font.sh (run after video driver loads)"
fi

if [ -n "${DISPLAY:-}" ] && [ "$X_DPI" -lt 192 ] 2>/dev/null; then
    error "X11 DPI too low for accessibility"
    log "Fix: ./scripts/setup-display.sh"
fi

log ""
success "=== DEBUG SESSION COMPLETE ==="
log "Log saved to: $LOG_FILE"
log "Review the log file for detailed information"

# Keep the log file for review
echo ""
echo "Debug log saved to: $LOG_FILE"
echo "Transfer this file back for analysis if needed."