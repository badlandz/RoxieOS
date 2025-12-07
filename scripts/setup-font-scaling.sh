#!/usr/local/bin/bash
# BAUX Font Scaling Setup
# Smart font scaling for X, terminal, and console
# Dec 07 2025

set -e

echo "=== BAUX FONT SCALING SETUP ==="
echo "Setting up smart font scaling for accessibility"

# X11 DPI scaling
if [ -n "${DISPLAY:-}" ]; then
    echo "Configuring X11 DPI scaling..."

    # Default DPI for accessibility
    X_DPI="${X_DPI:-192}"

    # Create Xresources if not exists
    XRESOURCES="$HOME/.Xresources"
    touch "$XRESOURCES"

    # Set DPI
    if ! grep -q "Xft.dpi" "$XRESOURCES"; then
        echo "Xft.dpi: $X_DPI" >> "$XRESOURCES"
    else
        sed -i.bak "s/Xft\.dpi:.*/Xft.dpi: $X_DPI/" "$XRESOURCES"
    fi

    # Merge into X
    xrdb -merge "$XRESOURCES"
    echo "✓ X11 DPI set to $X_DPI"
fi

# Terminal font scaling (for st with xrandrfontsize patch)
# Note: Requires st patched with xrandrfontsize
if command -v xrandr >/dev/null 2>&1; then
    echo "Terminal font scaling available via xrandrfontsize patch"
    echo "Use: printf '\\33]50;%s\\007' 'JetBrains Mono:size=14'"
fi

# Console font scaling
if command -v vidcontrol >/dev/null 2>&1; then
    echo "Console font scaling available"
    echo "Current console font:"
    doas vidcontrol -i active 2>/dev/null || echo "Unable to detect"

    echo "To change console font:"
    echo "  doas vidcontrol -f 8x16      # Standard readable"
    echo "  doas vidcontrol -f iso-8x16  # Alternative readable"
    echo "  Note: 16x32 not available on FreeBSD console"
    echo "  Use X11 with high DPI for true accessibility"
fi

echo
echo "=== FONT SCALING CONFIGURED ==="
echo "Restart X session for DPI changes to take effect"
echo "Use terminal escape sequences for runtime font changes"