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

echo "bvi installed successfully!"
echo "Run 'bvi filename' to edit with automatic editor detection"
echo "Uses neovim if available, falls back to vim/vi"