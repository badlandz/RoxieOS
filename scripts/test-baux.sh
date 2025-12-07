#!/usr/local/bin/bash
# BAUX System Test Script
# Tests BAUX components after installation

echo "BAUX System Test Starting..."
echo "============================="

# Test bbase (keymaps)
echo ""
echo "Testing bbase (keymaps)..."
if [ -f /usr/share/syscons/keymaps/baux.kbd ]; then
    echo "✅ bbase keymap installed"
    echo "   Run: doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd"
    echo "   Run: doas sysrc keymap=baux && reboot"
else
    echo "❌ bbase keymap NOT found"
fi

# Test baux (session manager)
echo ""
echo "Testing baux (session manager)..."
if [ -x /usr/local/bin/baux ]; then
    echo "✅ baux script installed"
    echo "   Run: baux"
else
    echo "❌ baux script NOT found"
fi

if [ -f /usr/local/share/tmux/baux.conf ]; then
    echo "✅ baux tmux config installed"
else
    echo "❌ baux tmux config NOT found"
fi

# Test bvi (editor wrapper)
echo ""
echo "Testing bvi (editor wrapper)..."
if [ -x /usr/local/bin/bvi ]; then
    echo "✅ bvi script installed"
    echo "   Run: bvi test.txt"
else
    echo "❌ bvi script NOT found"
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