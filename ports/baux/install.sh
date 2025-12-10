#!/usr/local/bin/bash
# BAUX Session Manager Installation Script
# Installs baux components on FreeBSD

set -e

echo "Installing BAUX Session Manager..."
echo "Current directory: $(pwd)"

# Clean up potential configuration conflicts from previous installs
echo "Cleaning up old BAUX configurations..."
doas rm -rf /usr/local/share/baux 2>/dev/null || true  # Remove old BAUX_HOME location
doas rm -f /usr/local/share/tmux-plugins/tpm 2>/dev/null || true  # Remove old plugin location
doas rm -f /usr/local/share/tmux-plugins/tmux-resurrect 2>/dev/null || true
doas rm -f /usr/local/share/tmux-plugins/tmux-continuum 2>/dev/null || true
doas rm -rf /var/tmp/baux-resurrect 2>/dev/null || true  # Clean resurrect data

# Check if source files exist
if [ ! -f "core/baux" ]; then
    echo "ERROR: core/baux not found in $(pwd)"
    exit 1
fi

if [ ! -f "core/tmux/baux.conf" ]; then
    echo "ERROR: core/tmux/baux.conf not found in $(pwd)"
    exit 1
fi

# Install the main script
echo "Copying baux to /usr/local/bin/..."
doas cp files/usr/local/bin/baux /usr/local/bin/
doas chmod +x /usr/local/bin/baux

# Verify copy succeeded
if [ ! -x "/usr/local/bin/baux" ]; then
    echo "ERROR: Failed to install baux script"
    exit 1
fi

# Install tmux configuration
echo "Installing tmux configuration..."
doas mkdir -p /usr/local/share/tmux
doas cp files/usr/local/share/tmux/baux.conf /usr/local/share/tmux/

# Verify copy succeeded
if [ ! -f "/usr/local/share/tmux/baux.conf" ]; then
    echo "ERROR: Failed to install tmux config"
    exit 1
fi

# Install tmux plugin manager
echo "Installing tmux plugin manager..."
doas mkdir -p /usr/local/share/tmux/plugins
doas git clone https://github.com/tmux-plugins/tpm /usr/local/share/tmux/plugins/tpm 2>/dev/null || echo "TPM already cloned or git failed"

# Create BAUX directories
echo "Creating BAUX directories..."
doas mkdir -p /usr/local/share/baux/tmux
doas mkdir -p /usr/local/share/baux/scripts
doas mkdir -p /usr/local/etc/baux

# Install BAUX scripts
echo "Installing BAUX scripts..."
if [ -d "files/usr/local/share/baux/scripts" ]; then
    doas cp files/usr/local/share/baux/scripts/* /usr/local/share/baux/scripts/
    doas chmod +x /usr/local/share/baux/scripts/*
else
    echo "Warning: BAUX scripts directory not found"
fi

# Create BAUX resurrect directory
echo "Creating BAUX resurrect directory..."
doas mkdir -p /var/tmp/baux-resurrect
doas chmod 755 /var/tmp/baux-resurrect

# Install tmux plugins to BAUX-managed location
echo "Installing tmux plugins for session resurrection..."
doas git clone https://github.com/tmux-plugins/tpm /usr/local/share/baux/tmux-plugins/tpm 2>/dev/null || echo "TPM already exists"
doas git clone https://github.com/tmux-plugins/tmux-resurrect /usr/local/share/baux/tmux-plugins/tmux-resurrect 2>/dev/null || echo "tmux-resurrect already exists"
doas git clone https://github.com/tmux-plugins/tmux-continuum /usr/local/share/baux/tmux-plugins/tmux-continuum 2>/dev/null || echo "tmux-continuum already exists"

echo ""
echo "✅ BAUX Session Manager installed successfully!"
echo ""
echo "Components installed:"
echo "  - baux binary: /usr/local/bin/baux"
echo "  - tmux config: /usr/local/share/tmux/baux.conf"
echo "  - BAUX scripts: /usr/local/share/baux/scripts/"
echo "  - neovim config: /usr/local/share/baux/nvim/"
echo "  - tmux plugins: /usr/local/share/baux/tmux-plugins/"
echo "  - resurrect dir: /var/tmp/baux-resurrect/"
echo ""
echo "Session restoration is now enabled!"
echo "BAUX sessions will automatically save and restore across reboots."
echo ""
echo "⚠️  IMPORTANT NOTES:"
echo "  - If you have ~/.tmux.conf, it may override BAUX config"
echo "  - Remove or backup ~/.tmux.conf if BAUX doesn't start properly"
echo "  - BAUX uses C-Space as tmux prefix (not C-b)"
echo "  - Kill existing tmux sessions if they use old configs: tmux kill-server"
echo ""
echo "To test: run 'baux'"