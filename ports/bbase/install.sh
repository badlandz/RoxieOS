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
doas mkdir -p /usr/share/syscons/keymaps

# Install the keymap
echo "Copying baux.kbd to /usr/share/syscons/keymaps/..."
doas cp baux.kbd /usr/share/syscons/keymaps/

# Verify copy succeeded
if [ ! -f "/usr/share/syscons/keymaps/baux.kbd" ]; then
    echo "ERROR: Failed to copy baux.kbd"
    exit 1
fi

# Set as default keymap
echo "Setting keymap to baux..."
doas sysrc keymap="baux"

echo "bbase installed successfully!"
echo "Reboot or run 'kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd' to activate"
echo "Caps Lock should now act as Escape globally"