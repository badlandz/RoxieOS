#!/bin/sh
# BAUX Session Manager Installation Script
# Installs baux components on FreeBSD

set -e

echo "Installing BAUX Session Manager..."

# Install the main script
sudo cp baux /usr/local/bin/
sudo chmod +x /usr/local/bin/baux

# Install tmux configuration
sudo mkdir -p /usr/local/share/tmux
sudo cp baux.conf /usr/local/share/tmux/

# Create BAUX directories
sudo mkdir -p /usr/local/share/baux/tmux
sudo mkdir -p /usr/local/etc/baux

echo "baux installed successfully!"
echo "Run 'baux' to start your BAUX session"
echo "Use Ctrl+Space as tmux prefix in BAUX sessions"