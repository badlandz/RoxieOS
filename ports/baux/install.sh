#!/usr/local/bin/bash
# BAUX Session Manager Installation Script
# Installs baux components on FreeBSD

set -e

echo "Installing BAUX Session Manager..."
echo "Current directory: $(pwd)"

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
doas cp core/baux /usr/local/bin/
doas chmod +x /usr/local/bin/baux

# Verify copy succeeded
if [ ! -x "/usr/local/bin/baux" ]; then
    echo "ERROR: Failed to install baux script"
    exit 1
fi

# Install tmux configuration
echo "Installing tmux configuration..."
doas mkdir -p /usr/local/share/tmux
doas cp core/tmux/baux.conf /usr/local/share/tmux/

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
doas mkdir -p /usr/local/etc/baux

echo "baux installed successfully!"
echo "Run 'baux' to start your BAUX session"
echo "Use Ctrl+Space as tmux prefix in BAUX sessions"
echo "To install tmux plugins (resurrect/continuum), run tmux and press Ctrl+Space then I"