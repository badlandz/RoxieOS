#!/bin/sh
# BVI Editor Wrapper Installation Script
# Installs bvi components on FreeBSD

set -e

echo "Installing BVI Editor Wrapper..."

# Install the wrapper script
sudo cp bvi.sh /usr/local/bin/bvi
sudo chmod +x /usr/local/bin/bvi

# Install configurations
sudo mkdir -p /usr/local/etc/bvi
sudo mkdir -p /usr/local/share/bvi
sudo cp -r lite/lua/* /usr/local/share/bvi/

echo "bvi installed successfully!"
echo "Run 'bvi filename' to edit with automatic editor detection"
echo "Uses neovim if available, falls back to vim/vi"