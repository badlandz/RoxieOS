#!/bin/bash
# BAUX Pre-Installation Setup
# Configure system for BAUX installation

set -euo pipefail

echo "=== BAUX PRE-INSTALLATION SETUP ==="
echo "Configuring FreeBSD system for BAUX installation"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Running as root - this script is designed for user setup"
    echo "   It's recommended to run as your regular user account"
    echo ""
fi

# Update packages
echo "Updating package database..."
pkg update || {
    echo "❌ pkg update failed"
    echo "Check internet connection"
    exit 1
}

# Install basic requirements
echo "Installing basic requirements..."
pkg install -y bash git || {
    echo "❌ Basic package installation failed"
    exit 1
}

# Configure doas for current user
USERNAME=$(whoami)
DOAS_CONF="/usr/local/etc/doas.conf"

echo "Configuring doas for user: $USERNAME"
if [ ! -f "$DOAS_CONF" ]; then
    touch "$DOAS_CONF"
fi

if ! grep -q "permit nopass $USERNAME" "$DOAS_CONF"; then
    echo "permit nopass $USERNAME" | doas tee -a "$DOAS_CONF" >/dev/null || {
        echo "❌ Failed to configure doas"
        echo "You may need to run: echo 'permit nopass $USERNAME' | sudo tee -a $DOAS_CONF"
        exit 1
    }
    echo "✓ doas configured for $USERNAME"
else
    echo "✓ doas already configured for $USERNAME"
fi

# Test doas
echo "Testing doas configuration..."
if doas whoami >/dev/null 2>&1; then
    echo "✓ doas working correctly"
else
    echo "❌ doas test failed"
    echo "Check doas configuration in $DOAS_CONF"
    exit 1
fi

# Clone repository
REPO_DIR="$HOME/src/RoxieOS"
if [ -d "$REPO_DIR" ]; then
    echo "Repository directory already exists: $REPO_DIR"
    echo "Updating existing repository..."
    cd "$REPO_DIR"
    git pull || echo "⚠️  Git pull failed, continuing with existing code"
else
    echo "Cloning BAUX repository..."
    mkdir -p "$HOME/src"
    cd "$HOME/src"
    git clone https://github.com/badlandz/RoxieOS.git || {
        echo "❌ Git clone failed"
        echo "Check internet connection and git installation"
        exit 1
    }
    cd RoxieOS
fi

echo ""
echo "=== PRE-INSTALLATION COMPLETE ==="
echo "System configured for BAUX installation"
echo ""
echo "NEXT STEPS:"
echo "1. Run: cd $HOME/src/RoxieOS"
echo "2. Run: ./scripts/install-baux-manual.sh"
echo "3. Or run: ./scripts/install-baux-unified.sh"
echo ""
echo "If you encounter font issues:"
echo "  ./scripts/launch-backup-terminal.sh  (guaranteed readable terminal)"
echo "  ./scripts/emergency-font-fix.sh      (try everything)"