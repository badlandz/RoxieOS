#!/bin/bash
# BAUX Font Installation and Verification
# Ensures required fonts are installed for accessibility

set -euo pipefail

echo "=== BAUX Font Installation Check ==="

# Check if x11-fonts package is installed
if pkg info | grep -q "x11-fonts"; then
    echo "✓ x11-fonts package is installed"
else
    echo "⚠ x11-fonts package not found"
    echo "Installing x11-fonts for console font support..."
    pkg install -y x11-fonts || {
        echo "❌ Failed to install x11-fonts"
        echo "Manual installation required: pkg install x11-fonts"
        exit 1
    }
    echo "✓ x11-fonts installed successfully"
fi

# Check console fonts
echo ""
echo "Console fonts available:"
CONSOLE_FONTS=$(ls -1 /usr/share/syscons/fonts/ 2>/dev/null | grep '\.fnt$' | sort)
echo "$CONSOLE_FONTS"

# Check for accessibility fonts
ACCESSIBILITY_FONTS=("TERMINAL_16x32.fnt" "TERMINAL_12x24.fnt" "TERMINAL_8x16.fnt")
MISSING_FONTS=()

for font in "${ACCESSIBILITY_FONTS[@]}"; do
    if echo "$CONSOLE_FONTS" | grep -q "$font"; then
        echo "✓ $font available"
    else
        echo "❌ $font missing"
        MISSING_FONTS+=("$font")
    fi
done

if [ ${#MISSING_FONTS[@]} -gt 0 ]; then
    echo ""
    echo "WARNING: Some accessibility fonts are missing"
    echo "This may cause font setting failures"
    echo "Missing: ${MISSING_FONTS[*]}"
    echo ""
    echo "Try reinstalling x11-fonts:"
    echo "pkg delete x11-fonts"
    echo "pkg install x11-fonts"
else
    echo ""
    echo "✓ All accessibility fonts are available"
fi

# Check X11 fonts
echo ""
echo "Checking X11 font support..."
if command -v fc-list >/dev/null 2>&1; then
    X11_FONTS=$(fc-list | wc -l)
    echo "✓ X11 font system available ($X11_FONTS fonts loaded)"

    # Check for monospace fonts
    MONOSPACE_FONTS=$(fc-list | grep -i monospace | wc -l)
    echo "✓ Monospace fonts available: $MONOSPACE_FONTS"
else
    echo "⚠ X11 font system not available (fontconfig not installed)"
fi

echo ""
echo "=== Font Setup Complete ==="
echo "Run ./scripts/setup-early-font.sh after video driver loads"
echo "Run ./scripts/setup-display.sh for X11 font configuration"
echo ""
echo "BACKUP OPTION:"
echo "If font issues persist, use: ./scripts/launch-backup-terminal.sh"
echo "This launches xterm with guaranteed large fonts"