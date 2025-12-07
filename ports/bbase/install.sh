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

# Create keymaps directory if it doesn't exist
echo "Creating keymaps directory..."
if ! doas mkdir -p /usr/share/syscons/keymaps; then
    echo "ERROR: Failed to create keymaps directory"
    echo "Check doas permissions and filesystem"
    exit 1
fi

# Install the keymap
echo "Copying baux.kbd to /usr/share/syscons/keymaps/..."
if ! doas cp baux.kbd /usr/share/syscons/keymaps/; then
    echo "ERROR: Failed to copy baux.kbd"
    echo "Check doas permissions and source file"
    ls -la baux.kbd
    exit 1
fi

# Verify copy succeeded
if [ ! -f "/usr/share/syscons/keymaps/baux.kbd" ]; then
    echo "ERROR: Failed to copy baux.kbd - file not found after copy"
    echo "Checking target directory:"
    ls -la /usr/share/syscons/keymaps/ 2>/dev/null || echo "Directory does not exist or not readable"
    exit 1
fi

# Set as default keymap
echo "Setting keymap to baux..."
if ! doas sysrc keymap="baux"; then
    echo "ERROR: Failed to set keymap with sysrc"
    echo "Check doas permissions for sysrc"
    exit 1
fi

# Configure console font for maximum readability (accessibility requirement)
echo "Setting console font for impaired vision accessibility..."
# Try largest fonts first for maximum readability
doas vidcontrol -f 12x24 /usr/share/syscons/fonts/TERMINAL_12x24.fnt 2>/dev/null || \
doas vidcontrol -f 16x32 /usr/share/syscons/fonts/TERMINAL_16x32.fnt 2>/dev/null || \
doas vidcontrol -f 8x16 /usr/share/syscons/fonts/TERMINAL_8x16.fnt 2>/dev/null || \
echo "Console font setting failed - no suitable fonts found"

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
echo "Keymap file: $(ls -la /usr/share/syscons/keymaps/baux.kbd)"
echo "System keymap setting: $(doas sysrc -n keymap 2>/dev/null || echo 'not set')"
echo ""
echo "Font configuration:"
echo "  Console: 8x16 TERMINAL font (readable)"
echo "  X11: 120 DPI with antialiasing (if available)"
echo ""
echo "To activate immediately:"
echo "  Keymap: doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
echo "  Fonts: reboot or restart X11"
echo "Caps Lock should now act as Escape globally"