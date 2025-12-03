#!/bin/bash
# RoxieOS Test Suite - Verify all components work

echo "🧪 CoseismicBSD Test Suite v1.0"
echo "=========================="

# Test package installation
echo "📦 Testing package installation..."
if pkg info | grep -q cbsd-base; then
    echo "✅ cbsd-base installed"
else
    echo "❌ cbsd-base missing"
fi

if pkg info | grep -q cbsd-terminal; then
    echo "✅ cbsd-terminal installed"
else
    echo "❌ cbsd-terminal missing"
fi

if pkg info | grep -q cbsd-wm; then
    echo "✅ cbsd-wm installed"
else
    echo "❌ cbsd-wm missing"
fi

# Test commands
echo ""
echo "🔧 Testing commands..."
if command -v cbsd-terminal >/dev/null 2>&1; then
    echo "✅ cbsd-terminal command available"
else
    echo "❌ cbsd-terminal command missing"
fi

if command -v bvi >/dev/null 2>&1; then
    echo "✅ bvi command available"
else
    echo "❌ bvi command missing"
fi

if command -v dwm-roxanne >/dev/null 2>&1; then
    echo "✅ dwm-roxanne available"
else
    echo "❌ dwm-roxanne missing"
fi

# Test branding
echo ""
echo "🎨 Testing branding..."

if uname -r | grep -q roxanne; then
    echo "✅ Kernel branding active"
else
    echo "ℹ️  Kernel branding requires reboot"
fi

if [ -f /usr/share/plymouth/themes/roxieos/roxieos.plymouth ]; then
    echo "✅ Plymouth theme installed"
else
    echo "❌ Plymouth theme missing"
fi

if [ -f /usr/share/grub/themes/roxieos/theme.txt ]; then
    echo "✅ GRUB theme installed"
else
    echo "❌ GRUB theme missing"
fi

# Test CoseismicBSD functionality
echo ""
echo "🚀 Testing CoseismicBSD functionality..."
if cbsd-terminal --diag >/dev/null 2>&1; then
    echo "✅ CoseismicBSD diagnostics working"
else
    echo "❌ CoseismicBSD diagnostics failed"
fi

echo ""
echo "🎉 Test complete! Check above for any issues."
echo "💡 Run 'cbsd-terminal' to start the CoseismicBSD environment!"