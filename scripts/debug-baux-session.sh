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
    log "Console font: $(doas vidcontrol -i active 2>/dev/null | head -1 || echo 'unknown')"
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
    fi
else
    log "kbdcontrol not available"
fi

# rc.conf check
if [ -f "/etc/rc.conf" ]; then
    KEYMAP_SETTING=$(grep "keymap" /etc/rc.conf || echo "not set")
    log "rc.conf keymap setting: $KEYMAP_SETTING"
fi

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
fi

if [[ "$CURRENT_KEYMAP" != *"baux"* ]]; then
    warn "BAUX keymap not active - Caps Lock won't work as Escape"
fi

log ""
success "=== DEBUG SESSION COMPLETE ==="
log "Log saved to: $LOG_FILE"
log "Review the log file for detailed information"

# Keep the log file for review
echo ""
echo "Debug log saved to: $LOG_FILE"
echo "Transfer this file back for analysis if needed."