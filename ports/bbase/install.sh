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

echo "bbase installed successfully!"
echo "Keymap file: $(ls -la /usr/share/syscons/keymaps/baux.kbd)"
echo "System keymap setting: $(doas sysrc -n keymap 2>/dev/null || echo 'not set')"
echo ""
echo "To activate immediately: doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
echo "To activate on boot: reboot required"
echo "Caps Lock should now act as Escape globally"