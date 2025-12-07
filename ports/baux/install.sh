#!/usr/local/bin/bash
# BAUX Session Manager Installation Script
# Installs baux components on FreeBSD

set -e

echo "Installing BAUX Session Manager..."

# Install the main script
doas cp baux /usr/local/bin/
doas chmod +x /usr/local/bin/baux

# Install tmux configuration
doas mkdir -p /usr/local/share/tmux
doas cp baux.conf /usr/local/share/tmux/

# Create BAUX directories
doas mkdir -p /usr/local/share/baux/tmux
doas mkdir -p /usr/local/etc/baux

echo "baux installed successfully!"
echo "Run 'baux' to start your BAUX session"
echo "Use Ctrl+Space as tmux prefix in BAUX sessions"