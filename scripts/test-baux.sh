#!/usr/local/bin/bash
# BAUX System Test Script
# Tests BAUX components after installation

echo "BAUX System Test Starting..."
echo "============================="

# Test bbase (keymaps)
echo ""
echo "Testing bbase (keymaps)..."
if [ -f /usr/share/syscons/keymaps/baux.kbd ]; then
    echo "✅ bbase keymap installed at /usr/share/syscons/keymaps/baux.kbd"
    echo "   Run: doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
    echo "   Run: doas sysrc keymap=baux && reboot"
else
    echo "❌ bbase keymap NOT found at /usr/share/syscons/keymaps/baux.kbd"
    echo "   Check if doas is configured: doas whoami"
    echo "   Check permissions: ls -la /usr/share/syscons/keymaps/"
fi

# Test baux (session manager)
echo ""
echo "Testing baux (session manager)..."
if [ -x /usr/local/bin/baux ]; then
    echo "✅ baux script installed at /usr/local/bin/baux"
    echo "   Run: baux"
else
    echo "❌ baux script NOT found at /usr/local/bin/baux"
    echo "   Check if doas is configured: doas whoami"
    echo "   Check permissions: ls -la /usr/local/bin/ | grep baux"
fi

if [ -f /usr/local/share/tmux/baux.conf ]; then
    echo "✅ baux tmux config installed at /usr/local/share/tmux/baux.conf"
else
    echo "❌ baux tmux config NOT found at /usr/local/share/tmux/baux.conf"
    echo "   Check permissions: ls -la /usr/local/share/tmux/"
fi

# Test bvi (editor wrapper)
echo ""
echo "Testing bvi (editor wrapper)..."
if [ -x /usr/local/bin/bvi ]; then
    echo "✅ bvi script installed at /usr/local/bin/bvi"
    echo "   Run: bvi test.txt"
else
    echo "❌ bvi script NOT found at /usr/local/bin/bvi"
    echo "   Check permissions: ls -la /usr/local/bin/ | grep bvi"
fi

# Check bvi configs
if [ -f /usr/local/etc/bvi/init.vim ]; then
    echo "✅ bvi neovim config installed"
else
    echo "❌ bvi neovim config NOT found at /usr/local/etc/bvi/init.vim"
fi

if [ -f /usr/local/etc/bvi/vimrc.tiny ]; then
    echo "✅ bvi vim fallback config installed"
else
    echo "❌ bvi vim fallback config NOT found at /usr/local/etc/bvi/vimrc.tiny"
fi

# Check dependencies
echo ""
echo "Checking dependencies..."
if command -v tmux >/dev/null 2>&1; then
    echo "✅ tmux installed"
else
    echo "❌ tmux NOT installed - run: pkg install tmux"
fi

if command -v nvim >/dev/null 2>&1; then
    echo "✅ neovim installed"
else
    echo "❌ neovim NOT installed - run: pkg install neovim"
fi

echo ""
echo "BAUX System Test Complete"
echo "=========================="
echo "Fix any ❌ issues, then test the components individually"