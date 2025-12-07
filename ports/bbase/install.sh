#!/usr/local/bin/bash
# BAUX Base System Installation Script
# Installs bbase components on FreeBSD

set -e

echo "Installing BAUX Base System (bbase)..."
echo "Current directory: $(pwd)"

# Check if baux.kbd exists
if [ ! -f "baux.kbd" ]; then
    echo "ERROR: baux.kbd not found in $(pwd)"
    exit 1
fi

# Check if keymaps directory exists
echo "Checking keymaps directory..."
if [ ! -d "/usr/share/syscons/keymaps" ]; then
    echo "WARNING: /usr/share/syscons/keymaps directory does not exist"
    echo "This is unusual for FreeBSD - console keymaps should be part of base system"
    echo ""
    echo "Trying to create the directory..."
    if ! doas mkdir -p /usr/share/syscons/keymaps 2>/dev/null; then
        echo "ERROR: Cannot create keymaps directory"
        echo "This indicates a system configuration issue"
        echo ""
        echo "Possible solutions:"
        echo "1. Run as root: mkdir -p /usr/share/syscons/keymaps"
        echo "2. Check if your FreeBSD installation is complete"
        echo "3. Verify you're using syscons (not vt) console driver"
        echo ""
        echo "For now, trying to install in /usr/local/share/syscons/keymaps instead..."
        doas mkdir -p /usr/local/share/syscons/keymaps 2>/dev/null || {
            echo "ERROR: Cannot create local keymaps directory either"
            exit 1
        }
        KEYMAP_DIR="/usr/local/share/syscons/keymaps"
        echo "Using local keymap directory: $KEYMAP_DIR"
    else
        KEYMAP_DIR="/usr/share/syscons/keymaps"
        echo "Created system keymap directory: $KEYMAP_DIR"
    fi
else
    KEYMAP_DIR="/usr/share/syscons/keymaps"
    echo "Found existing keymap directory: $KEYMAP_DIR"
fi

# Install the keymap
echo "Copying baux.kbd to $KEYMAP_DIR/..."
if ! doas cp baux.kbd "$KEYMAP_DIR/"; then
    echo "ERROR: Failed to copy baux.kbd to $KEYMAP_DIR"
    echo "Check doas permissions and source file"
    ls -la baux.kbd
    exit 1
fi

# Verify copy succeeded
if [ ! -f "$KEYMAP_DIR/baux.kbd" ]; then
    echo "ERROR: Failed to copy baux.kbd - file not found after copy"
    echo "Checking target directory:"
    ls -la "$KEYMAP_DIR/" 2>/dev/null || echo "Directory does not exist or not readable"
    exit 1
fi

# Set as default keymap (multiple methods for reliability)
echo "Setting keymap to baux..."

# Method 1: sysrc (persistent)
if ! doas sysrc keymap="baux"; then
    echo "WARNING: sysrc keymap setting failed, trying alternative methods"
fi

# Method 2: Direct rc.conf edit (backup)
if ! grep -q "keymap.*baux" /etc/rc.conf 2>/dev/null; then
    echo 'keymap="baux"' | doas tee -a /etc/rc.conf >/dev/null
fi

# Method 3: Immediate application
echo "Applying keymap immediately..."
if ! doas kbdcontrol -l "$KEYMAP_DIR/baux.kbd"; then
    echo "ERROR: Failed to load keymap immediately"
    echo "Check if keymap file exists and is readable"
    ls -la /usr/share/syscons/keymaps/baux.kbd
    exit 1
fi

# Method 4: Verify it took effect
echo "Verifying keymap is active..."
CURRENT_KEYMAP=$(doas kbdcontrol -d | head -1)
if [[ "$CURRENT_KEYMAP" == *"baux"* ]]; then
    echo "✓ Keymap successfully applied"
else
    echo "WARNING: Keymap may not be active yet (reboot may be required)"
    echo "Current keymap: $CURRENT_KEYMAP"
fi

# Configure console font for maximum readability (accessibility requirement)
echo "Setting console font for impaired vision accessibility..."

# Check what fonts are actually available
AVAILABLE_FONTS=$(ls -1 /usr/share/syscons/fonts/ 2>/dev/null | grep '\.fnt$' | sort)
echo "Available console fonts:"
echo "$AVAILABLE_FONTS" | head -5

# Try largest fonts first for maximum readability
# Note: vidcontrol may not work if video driver isn't loaded yet during install
if echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_16x32.fnt" && \
   doas vidcontrol -f 16x32 /usr/share/syscons/fonts/TERMINAL_16x32.fnt 2>/dev/null; then
    echo "✓ Set console font to 16x32 (maximum readability)"
elif echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_12x24.fnt" && \
     doas vidcontrol -f 12x24 /usr/share/syscons/fonts/TERMINAL_12x24.fnt 2>/dev/null; then
    echo "✓ Set console font to 12x24 (very readable)"
elif echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_8x16.fnt" && \
     doas vidcontrol -f 8x16 /usr/share/syscons/fonts/TERMINAL_8x16.fnt 2>/dev/null; then
    echo "✓ Set console font to 8x16 (minimum acceptable)"
else
    echo "WARNING: Console font setting failed during install"
    if [ -z "$AVAILABLE_FONTS" ]; then
        echo "  No console fonts found - install x11-fonts package"
        echo "  Run after install: pkg install x11-fonts"
    else
        echo "  Available fonts: $AVAILABLE_FONTS"
        echo "  Font will be set after video driver loads during boot"
        echo "  Run after boot: ./scripts/setup-early-font.sh"
    fi
fi

# Show current font setting
CURRENT_FONT=$(doas vidcontrol -i active 2>/dev/null | head -1 || echo "unknown")
echo "Current console font: $CURRENT_FONT"

# Configure X11 fonts if X11 is available
if command -v xrdb >/dev/null 2>&1; then
    echo "Configuring X11 fonts for accessibility..."
    XRESOURCES="$HOME/.Xresources"
    touch "$XRESOURCES"

    # Add BAUX font settings for accessibility if not already present
    if ! grep -q "Xft.dpi" "$XRESOURCES"; then
        echo "! BAUX Accessibility Font Settings" >> "$XRESOURCES"
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
    fi

    xrdb -merge "$XRESOURCES" 2>/dev/null || echo "X11 font config failed (expected if no X11)"
fi

echo "bbase installed successfully!"
echo "Keymap file: $(ls -la "$KEYMAP_DIR/baux.kbd")"
echo "Keymap directory: $KEYMAP_DIR"
echo "System keymap setting: $(doas sysrc -n keymap 2>/dev/null || echo 'not set')"
echo ""
echo "Font configuration:"
echo "  Console: 8x16 TERMINAL font (readable)"
echo "  X11: 120 DPI with antialiasing (if available)"
echo ""
echo "To activate immediately:"
echo "  Keymap: doas kbdcontrol -l $KEYMAP_DIR/baux.kbd"
echo "  Fonts: reboot or restart X11"
echo "Caps Lock should now act as Escape globally"
echo ""
echo "NOTE: If keymap directory was created in /usr/local/share/syscons/keymaps,"
echo "you may need to ensure kbdcontrol can find it, or move files to /usr/share/syscons/keymaps/"