# BAUX Manual Installation Guide for X300 ThinkPad
# Run these commands on your FreeBSD X300 system

## Prerequisites
# Ensure you have basic development tools
pkg update
pkg install bash git neovim tmux

## Install bbase (Foundation)
echo "Installing bbase..."
cd /path/to/RoxieOS/ports/bbase
sudo ./install.sh

# Test keymap
sudo kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd
echo "Caps Lock should now be Escape. Test it!"

## Install baux (Session Manager)
echo "Installing baux..."
cd /path/to/RoxieOS/ports/baux
sudo ./install.sh

# Test session manager
baux --help
echo "baux should show help. Try 'baux' to start session"

## Install bvi (Editor)
echo "Installing bvi..."
cd /path/to/RoxieOS/ports/bvi
sudo ./install.sh

# Test editor
bvi --version 2>/dev/null || echo "bvi wrapper ready"
echo "Try 'bvi test.txt' to edit a file"

## Run System Test
echo "Running system test..."
cd /path/to/RoxieOS/scripts
./test-baux.sh

## Next Steps
echo "Core BAUX components installed!"
echo "Next: Test bwm (window manager) and chaos (screensaver)"
echo "Then: Implement live USB persistence"