#!/usr/local/bin/bash
# BAUX Workstation Setup Script
# Complete setup for 192.168.33.101 (baux01)
# Run this after git pull on the workstation

set -e

echo "=== BAUX WORKSTATION SETUP ==="
echo "Setting up BAUX on FreeBSD workstation"

# Update packages
echo "Updating packages..."
doas pkg update
doas pkg upgrade -y

# Install prerequisites
echo "Installing prerequisites..."
doas pkg install -y bash git neovim tmux xterm rsync misc/console-fonts

# Install X11 if not present
if ! pkg info x11/xorg >/dev/null 2>&1; then
    echo "Installing X11..."
    doas pkg install -y x11/xorg x11/xinit x11/xrdb x11/xdpyinfo x11/xrandr x11/xset
fi

# Set console font
echo "Setting console font..."
doas vidcontrol -f iso-8x16

# Install BAUX packages
echo "Installing BAUX packages..."
cd ~/src/RoxieOS
/usr/local/bin/bash ./scripts/install-baux-manual.sh

# Setup X11 accessibility
echo "Setting up X11 accessibility..."
echo "Xft.dpi: 192" > ~/.Xresources
echo "Xft.antialias: true" >> ~/.Xresources
echo "Xft.hinting: true" >> ~/.Xresources

# Create .xinitrc if needed
if [ ! -f ~/.xinitrc ]; then
    cat > ~/.xinitrc << 'EOF'
#!/usr/local/bin/bash
xrdb -merge ~/.Xresources
exec baux
EOF
    chmod +x ~/.xinitrc
fi

echo ""
echo "=== SETUP COMPLETE ==="
echo "Run 'startx' to start X11 with BAUX"
echo "Console font set to iso-8x16"
echo "X11 DPI set to 192 for accessibility"
echo ""
echo "Test commands:"
echo "  doas vidcontrol -i active    # Check console font"
echo "  xrdb -query | grep dpi       # Check X DPI"
echo "  baux --help                  # Test BAUX"
echo "  bvi --version                # Test editor"