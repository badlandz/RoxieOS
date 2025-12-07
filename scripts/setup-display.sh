#!/usr/local/bin/bash
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

            # Limit to 1920x1280 maximum (user requirement)
            if [ "$WIDTH" -gt 1920 ] || [ "$HEIGHT" -gt 1280 ]; then
                echo "High resolution detected ($CURRENT_RES), limiting to 1920x1280 for accessibility"

                # Try to set optimal resolution
                if command -v xrandr >/dev/null 2>&1; then
                    echo "Attempting to set 1920x1280 resolution..."
                    xrandr --output $(xrandr | grep " connected" | cut -d' ' -f1) --mode 1920x1280 2>/dev/null || \
                    xrandr --output $(xrandr | grep " connected" | cut -d' ' -f1) --mode 1920x1200 2>/dev/null || \
                    echo "Could not set target resolution, keeping current"
                fi
            elif [ "$WIDTH" -le 1920 ] && [ "$HEIGHT" -le 1280 ]; then
                echo "Resolution is within acceptable limits ($CURRENT_RES)"
            fi
        fi
    fi

    # Configure X11 fonts for accessibility (20pt minimum requirement)
    XRESOURCES="$HOME/.Xresources"
    touch "$XRESOURCES"

    if ! grep -q "BAUX Display Config" "$XRESOURCES"; then
        echo "! BAUX Display Config - $(date)" >> "$XRESOURCES"
        echo "! High DPI settings for impaired vision accessibility"
        echo "Xft.dpi: 192" >> "$XRESOURCES"  # Increased from 120 for 20pt effective size
        echo "Xft.antialias: true" >> "$XRESOURCES"
        echo "Xft.hinting: true" >> "$XRESOURCES"
        echo "Xft.hintstyle: hintfull" >> "$XRESOURCES"  # Better hinting for readability
        echo "Xft.rgba: rgb" >> "$XRESOURCES"
        echo "Xft.lcdfilter: lcddefault" >> "$XRESOURCES"
        echo "! Large default font size"
        echo "*.font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*" >> "$XRESOURCES"
        echo "URxvt.font: xft:Monospace:size=20" >> "$XRESOURCES"
        echo "XTerm*faceName: Monospace:size=20" >> "$XRESOURCES"
    fi

    xrdb -merge "$XRESOURCES" 2>/dev/null || echo "X11 config merge failed"

    # Also try to set GTK font size for broader compatibility
    GTK_CONFIG="$HOME/.gtkrc-2.0"
    if [ ! -f "$GTK_CONFIG" ] || ! grep -q "font_name" "$GTK_CONFIG"; then
        echo "gtk-font-name = \"Monospace 20\"" >> "$GTK_CONFIG"
    fi

else
    echo "Console environment detected"

    # Configure console font for maximum readability (20pt equivalent)
    if command -v vidcontrol >/dev/null 2>&1; then
        echo "Setting console font to large size for impaired vision..."

        # Try largest available fonts first
        doas vidcontrol -f 12x24 /usr/share/syscons/fonts/TERMINAL_12x24.fnt 2>/dev/null || \
        doas vidcontrol -f 16x32 /usr/share/syscons/fonts/TERMINAL_16x32.fnt 2>/dev/null || \
        doas vidcontrol -f 8x16 /usr/share/syscons/fonts/TERMINAL_8x16.fnt 2>/dev/null || \
        echo "No suitable console fonts found, console may be hard to read"

        CURRENT_FONT=$(doas vidcontrol -i active 2>/dev/null | head -1 || echo "unknown")
        echo "Console font set to: $CURRENT_FONT"
    else
        echo "vidcontrol not available - console font configuration skipped"
    fi
fi

# Hardware-specific configuration
HARDWARE_MODEL=$(sysctl -n hw.model 2>/dev/null || echo "unknown")

case "$HARDWARE_MODEL" in
    *"ThinkPad X300"*)
        echo "X300 ThinkPad detected - applying special accessibility configuration"
        echo "X300 native resolution is typically 1024x768 (4:3 aspect ratio)"

        # For X300, ensure we're not exceeding native resolution
        if [ -n "${DISPLAY:-}" ] && command -v xrandr >/dev/null 2>&1; then
            echo "Setting X300 to optimal resolution for readability..."
            # Try to set a readable resolution for X300
            xrandr --output $(xrandr | grep " connected" | cut -d' ' -f1) --mode 1024x768 2>/dev/null || \
            echo "X300 resolution setting failed, using current resolution"
        fi

        # Extra large fonts for X300's small screen
        if [ -n "${DISPLAY:-}" ]; then
            echo "Xft.dpi: 240" >> "$HOME/.Xresources"  # Even higher DPI for X300
            xrdb -merge "$HOME/.Xresources" 2>/dev/null || true
        fi
        ;;
    *"Raspberry Pi"*)
        echo "Raspberry Pi detected - applying appropriate font sizing"
        ;;
    *)
        echo "Generic hardware detected - using standard accessibility configuration"
        ;;
esac

echo "Display setup complete!"
echo "Restart X11 or reboot for font changes to take effect."