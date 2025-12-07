#!/usr/local/bin/bash
# BAUX X300 Hardware Verification
# Comprehensive testing for X300 ThinkPad compatibility
# Dec 07 2025

set -euo pipefail

echo "=== BAUX X300 HARDWARE VERIFICATION ==="
echo "Testing BAUX components on X300 ThinkPad"
echo

# Run keymap verification
echo "--- Keymap Verification ---"
if [ -x "./scripts/verify-baux-keymap.sh" ]; then
    ./scripts/verify-baux-keymap.sh
else
    echo "Keymap verification script not found"
fi

echo
echo "--- Display Verification ---"
if [ -x "./scripts/verify-display.sh" ]; then
    ./scripts/verify-display.sh
else
    echo "Display verification script not found"
fi

echo
echo "--- Session Verification ---"
# Check if baux is installed and working
if command -v baux >/dev/null 2>&1; then
    echo "✓ baux session manager installed"
    # Check if tmux is configured
    if [ -f "$HOME/.tmux.conf" ] && grep -q "baux" "$HOME/.tmux.conf"; then
        echo "✓ tmux configured with BAUX"
    else
        echo "⚠ tmux not configured with BAUX"
    fi
else
    echo "✗ baux session manager not installed"
fi

echo
echo "--- Editor Verification ---"
if command -v bvi >/dev/null 2>&1; then
    echo "✓ bvi editor wrapper installed"
    # Test if it can start (without hanging)
    timeout 5 bvi --version >/dev/null 2>&1 && echo "✓ bvi starts successfully" || echo "⚠ bvi startup issue"
else
    echo "✗ bvi editor not installed"
fi

echo
echo "--- AI Integration Verification ---"
if command -v baux-bot >/dev/null 2>&1; then
    echo "✓ baux-bot AI assistant installed"
else
    echo "⚠ baux-bot not installed"
fi

if command -v xai-chat >/dev/null 2>&1; then
    echo "✓ xai-chat XAI client installed"
else
    echo "⚠ xai-chat not installed"
fi

echo
echo "=== VERIFICATION COMPLETE ==="
echo "X300 ThinkPad compatibility check done"
echo "Review warnings above and fix as needed"