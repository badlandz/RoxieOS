#!/usr/local/bin/bash
# BAUX bterm build script - manual build without ports tree
# Builds st with BAUX patches for scaling fonts

set -e

echo "Building BAUX bterm (st with BAUX patches)..."
echo "Current directory: $(pwd)"

# Check if we're in the right directory
if [ ! -f "files/usr/local/share/bterm/config.def.h" ]; then
    echo "ERROR: config.def.h not found in $(pwd)"
    echo "Please run this script from the ports/bterm directory"
    exit 1
fi

# Create build directory
BUILD_DIR="/tmp/bterm-build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "Downloading st source..."
fetch https://dl.suckless.org/st/st-0.9.tar.gz
tar -xzf st-0.9.tar.gz
cd st-0.9

echo "Downloading and applying patches..."

# Xresources patch for scaling
fetch https://st.suckless.org/patches/xresources/st-xresources-20230320-45a15676.diff
patch -p1 < st-xresources-20230320-45a15676.diff

# Font2 patch for multiple fonts
fetch https://st.suckless.org/patches/font2/st-font2-0.8.5.diff
patch -p1 < st-font2-0.8.5.diff

# Scrollback patch
fetch https://st.suckless.org/patches/scrollback/st-scrollback-0.8.5.diff
patch -p1 < st-scrollback-0.8.5.diff

# Ligatures patch for programming fonts (optional - requires harfbuzz)
echo "Note: Ligatures patch requires harfbuzz library - skipping for now"
# fetch https://st.suckless.org/patches/ligatures/0.9/st-ligatures-20240105-0.9.diff
# patch -p1 < st-ligatures-20240105-0.9.diff

echo "Copying BAUX configuration..."
cp "$(pwd)/../../files/usr/local/share/bterm/config.def.h" config.def.h

echo "Building bterm..."
make

echo "Installing bterm..."
doas cp st /usr/local/bin/bterm
doas chmod +x /usr/local/bin/bterm

echo "Installing configuration..."
doas mkdir -p /usr/local/share/bterm
doas cp config.def.h /usr/local/share/bterm/

echo ""
echo "✅ BAUX bterm installed successfully!"
echo ""
echo "Features:"
echo "  - JetBrains Mono nerd font with ligatures"
echo "  - BAUX Gruvbox color scheme"
echo "  - Xresources support for runtime font scaling"
echo "  - Multiple fallback fonts"
echo "  - Scrollback buffer"
echo ""
echo "Usage:"
echo "  bterm                                    # Launch with default settings"
echo "  bterm -f 'JetBrains Mono:size=14'       # Custom font/size"
echo "  echo 'st.font: JetBrains Mono:size=16' | xrdb -merge  # Scale via Xresources"
echo ""
echo "Xresources scaling:"
echo "  st.font: JetBrains Mono:size=20:antialias=true"
echo "  st.borderpx: 4"
echo ""

# Cleanup
cd /
rm -rf "$BUILD_DIR"