#!/usr/local/bin/bash
# BAUX Font and Terminal Setup for .133
# Manual installation of fonts and bterm for immediate usability

set -e

echo "=== BAUX Font and Terminal Setup for .133 ==="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[SETUP]${NC} $*" >&2; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }

# Check if running as root or with doas
if [[ $EUID -eq 0 ]]; then
    SUDO=""
elif command -v doas >/dev/null 2>&1; then
    SUDO="doas"
else
    SUDO="sudo"
fi

log "Using $SUDO for privileged operations"

# Function to install a font port
install_font() {
    local font_name="$1"
    local font_desc="$2"

    log "Installing $font_name: $font_desc"

    if [[ -d "/usr/ports/x11-fonts/$font_name" ]]; then
        cd "/usr/ports/x11-fonts/$font_name"
        if $SUDO make install clean; then
            log "✓ $font_name installed successfully"
        else
            warn "✗ $font_name installation failed"
        fi
    else
        warn "Font port $font_name not found"
    fi
}

# Install core fonts needed for bterm
log "Installing core BAUX fonts..."

install_font "jetbrains-mono" "Primary terminal font with ligatures"
install_font "atkinson-hyperlegible" "Accessibility font fallback"
install_font "hack" "Clear monospace fallback"
install_font "firacode" "Programming font with ligatures"

log "Updating font cache..."
fc-cache -f -v >/dev/null 2>&1 || warn "Font cache update failed"

# Check if fonts are available
log "Checking font availability..."
if fc-list | grep -i "jetbrains" >/dev/null; then
    log "✓ JetBrains Mono font found"
else
    warn "✗ JetBrains Mono font not found"
fi

# Build bterm manually
log "Building BAUX bterm (st with patches)..."

BAUX_ROOT="/home/badlandz/src/RoxieOS"  # Adjust path as needed
BTERM_DIR="$BAUX_ROOT/ports/bterm"

if [[ ! -d "$BTERM_DIR" ]]; then
    error "bterm directory not found: $BTERM_DIR"
    exit 1
fi

cd "$BTERM_DIR"

# Run the build script
if [[ -x "./build.sh" ]]; then
    log "Running bterm build script..."
    ./build.sh
    log "✓ bterm built and installed"
else
    error "build.sh not found or not executable"
    exit 1
fi

# Verify installation
log "Verifying installations..."

if command -v bterm >/dev/null 2>&1; then
    log "✓ bterm command found"
else
    error "✗ bterm command not found"
fi

# Test font loading
log "Testing font loading..."
if bterm -f "JetBrains Mono:size=12" -e echo "Font test successful" >/dev/null 2>&1; then
    log "✓ bterm can load JetBrains Mono font"
else
    warn "✗ bterm font loading test failed"
fi

echo
echo "=== Setup Complete ==="
echo
echo "Available fonts:"
fc-list | grep -E "(JetBrains|Atkinson|Hack|Fira)" | head -10

echo
echo "Usage:"
echo "  bterm                                    # Launch with JetBrains Mono"
echo "  bterm -f 'Hack:size=14'                 # Use Hack font"
echo "  bterm -f 'Atkinson Hyperlegible:size=16' # Use accessibility font"
echo
echo "Xresources scaling (add to ~/.Xresources):"
echo "  st.font: JetBrains Mono:size=14:antialias=true"
echo "Then run: xrdb -merge ~/.Xresources"
echo
echo "Test in BAUX: Press Alt-b to launch bterm from tmux"
echo
log "Setup complete! You now have a proper terminal for debugging."