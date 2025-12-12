#!/usr/local/bin/bash
# BAUX-BOT v2.0 Installation Script

set -e

echo "Installing BAUX-BOT v2.0..."

# Install v1.x compatibility scripts
echo "Installing v1.x compatibility scripts..."
doas mkdir -p /usr/local/bin
doas cp files/usr/local/bin/* /usr/local/bin/
doas chmod +x /usr/local/bin/baux-bot*

# Install v2.0 components
echo "Installing v2.0 components..."
doas mkdir -p /usr/local/share/baux/baux-bot
doas cp -r v2-shared /usr/local/share/baux/baux-bot/
doas cp -r v2-client /usr/local/share/baux/baux-bot/
doas cp -r v2-router /usr/local/share/baux/baux-bot/
doas cp -r v2-server /usr/local/share/baux/baux-bot/

# Install TMUX config updates
echo "Installing TMUX configuration..."
doas cp ../baux/core/tmux/baux.conf /usr/local/share/tmux/baux.conf

echo "BAUX-BOT v2.0 installation complete!"
echo "Run 'baux-bot-client --help' to test"
