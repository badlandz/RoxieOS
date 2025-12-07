#!/bin/bash
# BAUX Keymap Installation Verification
# Simple, effective verification following Unix philosophy

set -euo pipefail

KEYMAP_FILE="/usr/local/share/syscons/keymaps/baux.kbd"
RC_CONF="/etc/rc.conf"

echo "=== BAUX Keymap Verification ==="

# Check 1: File exists and is readable
if [ -r "$KEYMAP_FILE" ]; then
    echo "✓ Keymap file exists and is readable: $KEYMAP_FILE"
else
    echo "✗ Keymap file missing or not readable: $KEYMAP_FILE"
    echo "  Install with: pkg install bbase"
    exit 1
fi

# Check 2: rc.conf configuration
if grep -q "keymap.*baux" "$RC_CONF" 2>/dev/null; then
    echo "✓ Keymap configured in rc.conf"
else
    echo "⚠ Keymap not configured in rc.conf"
    echo "  Add: keymap=\"baux\""
    echo "  Then reboot or run: sudo kbdcontrol -l $KEYMAP_FILE"
fi

# Check 3: Test keymap loading (if kbdcontrol available)
if command -v kbdcontrol >/dev/null 2>&1; then
    if kbdcontrol -l "$KEYMAP_FILE" 2>/dev/null; then
        echo "✓ Keymap format is valid"
    else
        echo "✗ Keymap format is invalid"
        exit 1
    fi
else
    echo "⚠ kbdcontrol not available (not on FreeBSD?)"
fi

echo ""
echo "=== Usage Instructions ==="
echo "Caps Lock now provides:"
echo "  Tap → Escape (for vim)"
echo "  Hold → Control (for emacs/shell)"
echo ""
echo "Test in console: Try tapping/holding Caps Lock"
echo "Test in X11: May need separate X11 configuration"