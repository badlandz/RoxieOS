#!/usr/local/bin/bash
# BAUX Workstation Setup Script
# Complete setup for 192.168.33.101 (baux01)
# Run this after git pull on the workstation

set -e

echo "=== BAUX WORKSTATION SETUP ==="
echo "Setting up BAUX on FreeBSD workstation"

# Check privileges
if [ "$(id -u)" -eq 0 ]; then
    echo "✓ Running as root"
    PKG_CMD="pkg"
    CP_CMD="cp"
else
    echo "Running as user - checking doas..."
    if doas true 2>/dev/null; then
        echo "✓ doas available"
        PKG_CMD="doas pkg"
        CP_CMD="doas cp"
    else
        echo "❌ doas not configured properly"
        echo "Configure doas with: su root -c 'echo \"permit nopass :wheel\" >> /etc/doas.conf'"
        echo "Or run this script as root: su root -c '/usr/local/bin/bash $0'"
        exit 1
    fi
fi

# Update packages
echo "Updating packages..."
$PKG_CMD update || echo "Package update failed - continuing"
$PKG_CMD upgrade -y || echo "Package upgrade failed - continuing"

# Install prerequisites
echo "Installing prerequisites..."
$PKG_CMD install -y bash git neovim tmux xterm rsync || echo "Some packages may already be installed"

# Try additional console fonts (may not be available)
echo "Attempting to install additional console fonts..."
$PKG_CMD install -y misc/console-fonts 2>/dev/null || echo "misc/console-fonts not available - using base fonts"

# Install X11 if not present
if ! $PKG_CMD info x11/xorg >/dev/null 2>&1; then
    echo "Installing X11..."
    $PKG_CMD install -y x11/xorg x11/xinit x11/xrdb x11/xdpyinfo x11/xrandr x11/xset
fi

# Configure X11 permissions
echo "Configuring X11 permissions..."
if ! groups $USER | grep -q video; then
    echo "Adding user to video group for X11 access..."
    $CP_CMD /usr/sbin/pw $CP_CMD pw 2>/dev/null || true  # Ensure pw is available
    $PKG_CMD usermod -a -G video $USER 2>/dev/null || echo "Note: May need to logout/login for group changes"
fi

# Create basic X11 config
if [ ! -f /etc/X11/xorg.conf ]; then
    echo "Creating basic X11 config..."
    cat > /tmp/xorg.conf << 'EOF'
Section "Device"
    Identifier "Card0"
    Driver "modesetting"
EndSection

Section "Screen"
    Identifier "Screen0"
    Device "Card0"
    DefaultDepth 24
EndSection
EOF
    $CP_CMD /tmp/xorg.conf /etc/X11/xorg.conf 2>/dev/null || echo "X11 config creation failed"
fi

# Set console font
echo "Setting console font..."
# Try different font names, fallback to default if fails
if $CP_CMD /usr/share/syscons/fonts/iso-8x16.fnt /usr/share/syscons/fonts/ 2>/dev/null && vidcontrol -f iso-8x16 2>/dev/null; then
    echo "✓ Set console font to iso-8x16"
elif vidcontrol -f cp437-8x16 2>/dev/null; then
    echo "✓ Set console font to cp437-8x16"
elif vidcontrol -f 8x16 2>/dev/null; then
    echo "✓ Set console font to 8x16"
else
    echo "⚠ Could not set console font, using default"
fi

# Install Ollama for AI
echo "Installing Ollama for AI assistance..."
$PKG_CMD install -y ollama || echo "Ollama install failed"

# Enable Ollama service
echo "Enabling Ollama service..."
$CP_CMD /usr/sbin/service $CP_CMD service 2>/dev/null || true
$PKG_CMD service ollama enable 2>/dev/null || echo "Service enable failed - may need manual setup"

# Pull default model
echo "Pulling default AI model..."
ollama pull llama3.2:3b 2>/dev/null || echo "Model pull failed - will happen on first use"

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
echo "Console font set to best available"
echo "X11 DPI set to 192 for accessibility"
echo "Ollama AI service enabled"
echo ""
echo "Test commands:"
echo "  doas vidcontrol -i active    # Check console font"
echo "  xrdb -query | grep dpi       # Check X DPI"
echo "  baux --help                  # Test BAUX"
echo "  bvi --version                # Test editor"
echo "  baux-bot                     # Test AI assistant"
echo ""
echo "If BAUX install failed due to permissions:"
echo "  su root -c '/usr/local/bin/bash ~/src/RoxieOS/scripts/setup-workstation.sh'"
echo "Or configure doas: su root -c 'echo \"permit nopass :wheel\" >> /etc/doas.conf'"
echo ""
echo "If X11 fails to start:"
echo "  Check if user is in video group: groups $USER"
echo "  Logout and login again for group changes"
echo "  Or run: doas usermod -a -G video $USER"