#!/bin/bash
# create-live-image.sh — Build RoxieOS live image with BAUX packages

set -e

echo "Building RoxieOS live image..."

# Prerequisites
echo "Ensure FreeBSD src is checked out and built"
echo "This script assumes /usr/src is ready"

# Customize release
mkdir -p /usr/local/etc/rc.d
# Add BAUX services, keymaps, etc.

# Build ISO
cd /usr/src
make release
make install
make package

echo "Live image created in /usr/obj/usr/src/amd64.amd64/release/"

# Post-build customization
echo "To customize:"
echo "1. Mount the ISO"
echo "2. Add BAUX packages to /packages"
echo "3. Update rc.conf with BAUX settings"
echo "4. Rebuild ISO with mkisofs or similar"

echo "Live image ready for testing."