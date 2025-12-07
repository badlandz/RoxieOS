#!/usr/local/bin/bash
# BVI Editor Wrapper Installation Script
# Installs bvi components on FreeBSD

set -e

echo "Installing BVI Editor Wrapper..."

# Install the wrapper script
doas cp src/bvi.sh /usr/local/bin/bvi
doas chmod +x /usr/local/bin/bvi

# Install configurations
doas mkdir -p /usr/local/etc/bvi
doas mkdir -p /usr/local/share/bvi
doas cp -r lite/lua/* /usr/local/share/bvi/

# Create bvi-specific neovim config
cat > /tmp/bvi_init.vim << 'EOF'
set runtimepath^=/usr/local/share/bvi
lua require("config.lazy")
EOF
doas mv /tmp/bvi_init.vim /usr/local/etc/bvi/init.vim

# Create minimal vimrc for fallback
cat > /tmp/bvi_vimrc.tiny << 'EOF'
set runtimepath^=/usr/local/share/bvi
syntax on
set background=dark
colorscheme gruvbox
EOF
doas mv /tmp/bvi_vimrc.tiny /usr/local/etc/bvi/vimrc.tiny

echo "bvi installed successfully!"
echo "Run 'bvi filename' to edit with automatic editor detection"
echo "Uses neovim if available, falls back to vim/vi"