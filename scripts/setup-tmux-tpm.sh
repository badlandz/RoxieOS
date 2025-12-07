#!/bin/bash
# BAUX Tmux TPM Setup
# Simple, effective TPM installation

set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_URL="https://github.com/tmux-plugins/tpm"

echo "=== BAUX Tmux TPM Setup ==="

# Install TPM if not present
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM..."
    git clone "$TPM_URL" "$TPM_DIR"
    echo "✓ TPM installed to $TPM_DIR"
else
    echo "✓ TPM already installed"
fi

# Install plugins
if [ -d "$TPM_DIR" ]; then
    echo "Installing tmux plugins..."
    "$TPM_DIR/bin/install_plugins" || echo "Note: Run 'tmux source ~/.tmux.conf' then press prefix+I to install plugins"
    echo "✓ Plugins installation initiated"
fi

echo ""
echo "=== Setup Complete ==="
echo "Reload tmux config: tmux source ~/.tmux.conf"
echo "Install plugins: Press prefix+I in tmux"
echo "Save session: prefix+C-s"
echo "Restore session: prefix+C-r"
