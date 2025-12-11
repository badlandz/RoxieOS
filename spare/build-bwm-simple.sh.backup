#!/bin/sh
# build-bwm-simple.sh - Simple dwm build for BAUXBSD using FreeBSD dwm

echo "Building BAUX Window Manager (bwm)..."

# Create build directory
mkdir -p /tmp/bwm-build
cd /tmp/bwm-build

# Copy FreeBSD dwm source from our patches
echo "Copying FreeBSD dwm source..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp -r "$SCRIPT_DIR/patches/upstream/dwm/"* .

# Copy our BAUX config.h
echo "Installing BAUX config.h..."
cp "$SCRIPT_DIR/ports/bwm/files/config.h" config.h

# Build dwm
echo "Building dwm..."
make

# Install as bwm
echo "Installing as bwm..."
sudo cp dwm /usr/local/bin/bwm
sudo chmod 755 /usr/local/bin/bwm

echo "BAUX Window Manager (bwm) installed!"
echo "Run with: bwm"
echo "Terminal: Alt+Shift+Enter (mate-terminal)"