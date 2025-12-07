#!/usr/local/bin/bash
# BVI Editor Wrapper Installation Script
# Installs bvi components on FreeBSD

set -e

echo "Installing BVI Editor Wrapper..."
echo "Current directory: $(pwd)"

# Check if source files exist
if [ ! -f "src/bvi.sh" ]; then
    echo "ERROR: src/bvi.sh not found in $(pwd)"
    exit 1
fi

if [ ! -d "lite/lua" ]; then
    echo "ERROR: lite/lua directory not found in $(pwd)"
    exit 1
fi

# Install the wrapper script
echo "Copying bvi.sh to /usr/local/bin/bvi..."
doas cp src/bvi.sh /usr/local/bin/bvi
doas chmod +x /usr/local/bin/bvi

# Verify copy succeeded
if [ ! -x "/usr/local/bin/bvi" ]; then
    echo "ERROR: Failed to install bvi script"
    exit 1
fi

# Install configurations
echo "Installing configurations..."
doas mkdir -p /usr/local/etc/bvi
doas mkdir -p /usr/local/share/bvi
doas cp -r lite/lua/* /usr/local/share/bvi/

# Create bvi-specific neovim config
echo "Creating neovim config..."
cat > /tmp/bvi_init.vim << 'EOF'
set runtimepath^=/usr/local/share/bvi
lua require("config.lazy")
EOF
doas mv /tmp/bvi_init.vim /usr/local/etc/bvi/init.vim

# Verify config creation
if [ ! -f "/usr/local/etc/bvi/init.vim" ]; then
    echo "ERROR: Failed to create init.vim"
    exit 1
fi

# Create minimal vimrc for fallback
echo "Creating vim fallback config..."
cat > /tmp/bvi_vimrc.tiny << 'EOF'
set runtimepath^=/usr/local/share/bvi
syntax on
set background=dark
colorscheme gruvbox
EOF
doas mv /tmp/bvi_vimrc.tiny /usr/local/etc/bvi/vimrc.tiny

# Verify config creation
if [ ! -f "/usr/local/etc/bvi/vimrc.tiny" ]; then
    echo "ERROR: Failed to create vimrc.tiny"
    exit 1
fi

echo "bvi installed successfully!"
echo "Run 'bvi filename' to edit with automatic editor detection"
echo "Uses neovim if available, falls back to vim/vi"