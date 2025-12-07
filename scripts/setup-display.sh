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

    # Backup existing Xresources
    if [ -f "$XRESOURCES" ] && [ ! -f "${XRESOURCES}.backup" ]; then
        cp "$XRESOURCES" "${XRESOURCES}.backup"
        echo "Backed up existing .Xresources to .Xresources.backup"
    fi

    if ! grep -q "BAUX Display Config" "$XRESOURCES"; then
        echo "! BAUX Display Config - $(date)" >> "$XRESOURCES"
        echo "! High DPI settings for impaired vision accessibility"
        echo "Xft.dpi: 192" >> "$XRESOURCES"  # High DPI for 20pt effective size
        echo "Xft.antialias: true" >> "$XRESOURCES"
        echo "Xft.hinting: true" >> "$XRESOURCES"
        echo "Xft.hintstyle: hintfull" >> "$XRESOURCES"  # Better hinting
        echo "Xft.rgba: rgb" >> "$XRESOURCES"
        echo "Xft.lcdfilter: lcddefault" >> "$XRESOURCES"
        echo "! Large default fonts for accessibility" >> "$XRESOURCES"
        echo "*.font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*" >> "$XRESOURCES"
        echo "URxvt.font: xft:Monospace:size=20" >> "$XRESOURCES"
        echo "XTerm*faceName: Monospace:size=20" >> "$XRESOURCES"
        echo "xterm*font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*" >> "$XRESOURCES"
    fi

    # Apply X11 settings immediately
    if xrdb -merge "$XRESOURCES" 2>/dev/null; then
        echo "✓ X11 font settings applied"
    else
        echo "⚠ X11 config merge failed - X11 may not be running"
    fi

    # Also try to set GTK font size for broader compatibility
    GTK_CONFIG="$HOME/.gtkrc-2.0"
    if [ ! -f "$GTK_CONFIG" ] || ! grep -q "font_name" "$GTK_CONFIG"; then
        echo "gtk-font-name = \"Monospace 20\"" >> "$GTK_CONFIG"
        echo "✓ GTK font settings configured"
    fi

    # Set global X11 font settings (system-wide)
    GLOBAL_XRESOURCES="/etc/X11/xinit/xresources"
    if [ -w "/etc/X11/xinit/" ] 2>/dev/null; then
        echo "! BAUX Global Font Settings" >> "$GLOBAL_XRESOURCES"
        echo "Xft.dpi: 192" >> "$GLOBAL_XRESOURCES"
        echo "*.font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*" >> "$GLOBAL_XRESOURCES"
        echo "✓ Global X11 font settings applied"
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

        # Check what fonts are actually available
        AVAILABLE_FONTS=$(doas ls -1 /usr/share/syscons/fonts/ 2>/dev/null | grep '\.fnt$' | sort)
        echo "Available console fonts:"
        echo "$AVAILABLE_FONTS" | head -5

        # Try largest available fonts first (check availability first)
        FONT_SET=false
        if echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_16x32.fnt" && \
           doas vidcontrol -f 16x32 /usr/share/syscons/fonts/TERMINAL_16x32.fnt 2>/dev/null; then
            echo "✓ Console font set to 16x32 (maximum readability)"
            FONT_SET=true
        elif echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_12x24.fnt" && \
             doas vidcontrol -f 12x24 /usr/share/syscons/fonts/TERMINAL_12x24.fnt 2>/dev/null; then
            echo "✓ Console font set to 12x24 (very readable)"
            FONT_SET=true
        elif echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_8x16.fnt" && \
             doas vidcontrol -f 8x16 /usr/share/syscons/fonts/TERMINAL_8x16.fnt 2>/dev/null; then
            echo "✓ Console font set to 8x16 (minimum acceptable)"
            FONT_SET=true
        fi

        if [ "$FONT_SET" = false ]; then
            echo "⚠ Console font setting failed"
            if [ -z "$AVAILABLE_FONTS" ]; then
                echo "  No .fnt files found in /usr/share/syscons/fonts/"
                echo "  Console fonts may be provided by base FreeBSD system"
                echo "  Or install additional fonts: pkg install x11-fonts"
            else
                echo "  Available fonts: $AVAILABLE_FONTS"
                echo "  Video driver may not be loaded yet - try after boot completes"
            fi
        fi

        # Show current font setting
        CURRENT_FONT=$(doas vidcontrol -i active 2>/dev/null | head -1 || echo "unknown")
        echo "Current console font: $CURRENT_FONT"
    else
        echo "vidcontrol not available - console font configuration skipped"
        echo "Install with: pkg install x11-fonts"
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

echo ""
echo "=== DISPLAY SETUP COMPLETE ==="
echo "Font and display settings have been configured for accessibility."
echo ""
echo "IMPORTANT NOTES:"
echo "1. Console fonts may not apply until after video driver loads during boot"
echo "2. X11 fonts require restarting X11 or rebooting to take effect"
echo "3. If fonts are still too small, run: ./scripts/setup-early-font.sh"
echo ""
echo "Current settings applied:"
echo "- Console: Attempted 16x32 or 12x24 font"
echo "- X11: 192 DPI with 20pt fonts"
echo "- X300: Special 240 DPI optimization"
echo ""
echo "To verify settings: ./scripts/verify-display.sh"