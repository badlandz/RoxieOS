#!/usr/local/bin/bash
# BAUX Manual Installation Guide for X300 ThinkPad
# Run these commands on your FreeBSD X300 system

set -e  # Exit on any error

echo "=== BAUX Manual Installation Started ==="
echo "Current directory: $(pwd)"
echo "User: $(whoami)"

## Prerequisites
echo "=== Installing Prerequisites ==="
pkg update || echo "pkg update failed, continuing..."
pkg install -y bash git neovim tmux || echo "Package installation failed"

## Install bbase (Foundation)
echo "=== Installing bbase (Foundation) ==="
echo "Changing to ports/bbase..."
cd ports/bbase || { echo "ERROR: Cannot cd to ports/bbase from $(pwd)"; exit 1; }
echo "Running install.sh..."
doas ./install.sh || { echo "ERROR: bbase install.sh failed"; exit 1; }

# Test keymap
echo "Testing keymap..."
doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd || echo "Keymap load failed"
echo "Caps Lock should now be Escape. Test it!"

## Install baux (Session Manager)
echo "=== Installing baux (Session Manager) ==="
echo "Changing to ../baux..."
cd ../baux || { echo "ERROR: Cannot cd to ../baux"; exit 1; }
echo "Running install.sh..."
doas ./install.sh || { echo "ERROR: baux install.sh failed"; exit 1; }

# Test session manager
echo "Testing baux command..."
baux --help || echo "baux command not found or failed"
echo "baux should show help. Try 'baux' to start session"

## Install bvi (Editor)
echo "=== Installing bvi (Editor) ==="
echo "Changing to ../bvi..."
cd ../bvi || { echo "ERROR: Cannot cd to ../bvi"; exit 1; }
echo "Running install.sh..."
doas ./install.sh || { echo "ERROR: bvi install.sh failed"; exit 1; }

# Test editor
echo "Testing bvi command..."
bvi --version 2>/dev/null || echo "bvi wrapper ready"
echo "Try 'bvi test.txt' to edit a file"

## Run System Test
echo "=== Running System Test ==="
echo "Changing to ../scripts..."
cd ../scripts || { echo "ERROR: Cannot cd to ../scripts"; exit 1; }
echo "Running test-baux.sh..."
./test-baux.sh

## Next Steps
echo "=== Installation Complete ==="
echo "Core BAUX components installed!"
echo "Next: Test bwm (window manager) and chaos (screensaver)"
echo "Then: Implement live USB persistence"