#!/usr/local/bin/bash
# BAUX Debug Script
# Run this to diagnose installation issues

echo "=== BAUX Debug Information ==="
echo "Date: $(date)"
echo "User: $(whoami)"
echo "Current directory: $(pwd)"
echo "FreeBSD version: $(freebsd-version)"
echo ""

echo "=== Doas Configuration ==="
doas whoami 2>/dev/null && echo "✅ doas is working" || echo "❌ doas is NOT configured"
echo ""

echo "=== Directory Permissions ==="
echo "/usr/local/bin permissions:"
ls -ld /usr/local/bin/
echo ""
echo "/usr/local/share permissions:"
ls -ld /usr/local/share/
echo ""
echo "/usr/share/syscons/keymaps permissions:"
ls -ld /usr/share/syscons/keymaps/
echo ""

echo "=== File Existence Checks ==="
echo "bbase keymap:"
ls -la /usr/share/syscons/keymaps/baux.kbd 2>/dev/null && echo "✅ Found" || echo "❌ NOT found"
echo ""
echo "baux script:"
ls -la /usr/local/bin/baux 2>/dev/null && echo "✅ Found" || echo "❌ NOT found"
echo ""
echo "baux tmux config:"
ls -la /usr/local/share/tmux/baux.conf 2>/dev/null && echo "✅ Found" || echo "❌ NOT found"
echo ""
echo "bvi script:"
ls -la /usr/local/bin/bvi 2>/dev/null && echo "✅ Found" || echo "❌ NOT found"
echo ""
echo "bvi configs:"
ls -la /usr/local/etc/bvi/ 2>/dev/null && echo "✅ Directory exists" || echo "❌ Directory NOT found"
echo ""

echo "=== PATH Check ==="
echo "PATH: $PATH"
echo "bash location: $(which bash 2>/dev/null || echo 'NOT found')"
echo "doas location: $(which doas 2>/dev/null || echo 'NOT found')"
echo ""

echo "=== Repository Check ==="
if [ -d "ports/bbase" ] && [ -d "ports/baux" ] && [ -d "ports/bvi" ]; then
    echo "✅ Repository structure looks correct"
else
    echo "❌ Repository structure incomplete"
    echo "Missing directories:"
    [ ! -d "ports/bbase" ] && echo "  - ports/bbase"
    [ ! -d "ports/baux" ] && echo "  - ports/baux"
    [ ! -d "ports/bvi" ] && echo "  - ports/bvi"
fi
echo ""

echo "=== Source File Checks ==="
echo "baux.kbd:"
ls -la ports/bbase/baux.kbd 2>/dev/null && echo "✅ Found" || echo "❌ NOT found"
echo ""
echo "baux script:"
ls -la ports/baux/core/baux 2>/dev/null && echo "✅ Found" || echo "❌ NOT found"
echo ""
echo "baux.conf:"
ls -la ports/baux/core/tmux/baux.conf 2>/dev/null && echo "✅ Found" || echo "❌ NOT found"
echo ""
echo "bvi.sh:"
ls -la ports/bvi/src/bvi.sh 2>/dev/null && echo "✅ Found" || echo "❌ NOT found"
echo ""

echo "=== Recommendations ==="
if ! doas whoami >/dev/null 2>&1; then
    echo "1. Configure doas: Add your user to /usr/local/etc/doas.conf"
    echo "   Example: permit nopass :wheel"
fi

if [ ! -f "/usr/local/bin/baux" ]; then
    echo "2. Try manual installation:"
    echo "   cd ports/bbase && doas ./install.sh"
    echo "   cd ../baux && doas ./install.sh"
    echo "   cd ../bvi && doas ./install.sh"
fi

echo ""
echo "Debug complete. Check above for issues."