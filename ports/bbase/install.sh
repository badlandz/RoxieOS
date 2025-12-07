#!/usr/local/bin/bash
# BAUX Base System Installation Script
# Installs bbase components on FreeBSD

set -e

echo "Installing BAUX Base System (bbase)..."

# Create keymaps directory if it doesn't exist
doas mkdir -p /usr/share/syscons/keymaps

# Install the keymap
doas cp baux.kbd /usr/share/syscons/keymaps/

# Set as default keymap
doas sysrc keymap="baux"

echo "bbase installed successfully!"
echo "Reboot or run 'kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd' to activate"
echo "Caps Lock should now act as Escape globally"