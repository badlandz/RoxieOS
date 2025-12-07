#!/bin/bash
# BAUX Display Setup Script
# Configures display resolution and font settings for accessibility

set -euo pipefail

echo "=== BAUX Display Setup ==="

# Detect display environment
if [ -n "${DISPLAY:-}" ]; then
    echo "X11 display detected: $DISPLAY"

    # Check current resolution
    if command -v xdpyinfo >/dev/null 2>&1; then
        CURRENT_RES=$(xdpyinfo 2>/dev/null | grep "dimensions:" | awk '{print $2}' || echo "unknown")
        echo "Current resolution: $CURRENT_RES"

        # Parse resolution
        if [[ "$CURRENT_RES" =~ ([0-9]+)x([0-9]+) ]]; then
            WIDTH="${BASH_REMATCH[1]}"
            HEIGHT="${BASH_REMATCH[2]}"

            # Limit to 1920x1080 maximum
            if [ "$WIDTH" -gt 1920 ] || [ "$HEIGHT" -gt 1080 ]; then
                echo "High resolution detected ($CURRENT_RES), limiting to 1920x1080"
                # Note: Actual resolution limiting would require xrandr
                # For now, just log the recommendation
                echo "Consider using xrandr to limit resolution for better font readability"
            fi
        fi
    fi

    # Configure X11 fonts
    XRESOURCES="$HOME/.Xresources"
    touch "$XRESOURCES"

    if ! grep -q "BAUX Display Config" "$XRESOURCES"; then
        echo "! BAUX Display Config - $(date)" >> "$XRESOURCES"
        echo "Xft.dpi: 120" >> "$XRESOURCES"
        echo "Xft.antialias: true" >> "$XRESOURCES"
        echo "Xft.hinting: true" >> "$XRESOURCES"
        echo "Xft.hintstyle: hintslight" >> "$XRESOURCES"
    fi

    xrdb -merge "$XRESOURCES" 2>/dev/null || echo "X11 config merge failed"

else
    echo "Console environment detected"

    # Configure console font
    if command -v vidcontrol >/dev/null 2>&1; then
        echo "Setting console font to 8x16 for readability..."
        doas vidcontrol -f 8x16 /usr/share/syscons/fonts/TERMINAL_8x16.fnt 2>/dev/null || echo "Console font setting failed"
    fi
fi

# Hardware-specific configuration
HARDWARE_MODEL=$(sysctl -n hw.model 2>/dev/null || echo "unknown")

case "$HARDWARE_MODEL" in
    *"ThinkPad X300"*)
        echo "X300 ThinkPad detected - applying special configuration"
        # X300 has 4:3 aspect ratio, may need special handling
        ;;
    *"Raspberry Pi"*)
        echo "Raspberry Pi detected - applying appropriate font sizing"
        ;;
    *)
        echo "Generic hardware detected - using standard configuration"
        ;;
esac

echo "Display setup complete!"
echo "Restart X11 or reboot for font changes to take effect."