#!/bin/sh
# build-bwm-port.sh - Build BAUX Window Manager port

echo "Building BAUX Window Manager (bwm) port..."

# Create build directory
mkdir -p /tmp/bwm-port-build
cd /tmp/bwm-port-build

# Download dwm source
echo "Downloading dwm source..."
curl -L https://dl.suckless.org/dwm/dwm-6.4.tar.gz | tar xz
cd dwm-6.4

# Copy our FreeBSD config
echo "Installing FreeBSD config.mk..."
cp ~/src/RoxieOS/ports/bwm/files/config.mk config.mk

# Copy our BAUX config
echo "Installing BAUX config.h..."
cp ~/src/RoxieOS/ports/bwm/files/config.h config.h

# Build dwm
echo "Building dwm..."
make

# Install
echo "Installing bwm..."
doas cp dwm /usr/local/bin/bwm
doas cp ~/src/RoxieOS/ports/bwm/files/status.sh /usr/local/bin/status.sh
doas chmod 755 /usr/local/bin/bwm /usr/local/bin/status.sh

echo "BAUX Window Manager (bwm) installed!"
echo "Run with: bwm"
echo "Terminal: Alt+Shift+Enter (mate-terminal)"