# Keymap Debug Steps for .133

## Immediate Diagnosis Commands

Run these on .133 to identify the keymap issue:

```bash
# 1. Check if baux.kbd exists and is readable
ls -la /usr/local/share/syscons/keymaps/baux.kbd
file /usr/local/share/syscons/keymaps/baux.kbd

# 2. Check rc.conf keymap setting
grep keymap /etc/rc.conf

# 3. Check current keymap status
kbdcontrol -d  # Show current keymap info

# 4. Test manual keymap loading
kbdcontrol -l /usr/local/share/syscons/keymaps/baux.kbd
echo "Test: Press Caps Lock - should act as Escape now"

# 5. Check if roxieos-base post-install ran
ls -la /usr/local/etc/roxieos/
cat /usr/local/etc/roxieos/setup-keymap

# 6. Check system logs for keymap errors
dmesg | grep -i keymap
```

## Potential Issues & Fixes

### Issue 1: rc.conf not updated
**Symptom:** `grep keymap /etc/rc.conf` shows nothing
**Fix:**
```bash
echo 'keymap="baux"' >> /etc/rc.conf
reboot
```

### Issue 2: Keymap file not installed
**Symptom:** `/usr/local/share/syscons/keymaps/baux.kbd` doesn't exist
**Fix:** Reinstall roxieos-base
```bash
cd /src/RoxieOS/ports/roxieos-base
make deinstall
make install
```

### Issue 3: Post-install didn't run
**Symptom:** Setup scripts exist but keymap not loaded
**Fix:** Run setup manually
```bash
/usr/local/etc/roxieos/setup-keymap
```

### Issue 4: Wrong keymap path
**Symptom:** File exists but kbdcontrol can't load it
**Fix:** Check if it's in the right location
```bash
# FreeBSD expects keymaps in /usr/share/syscons/keymaps/
cp /usr/local/share/syscons/keymaps/baux.kbd /usr/share/syscons/keymaps/
echo 'keymap="baux"' >> /etc/rc.conf
reboot
```

## Emergency Manual Fix

If nothing works, manually load the keymap:

```bash
# Create emergency keymap loader
cat > /root/load_baux_keymap.sh << 'EOF'
#!/bin/sh
# Emergency BAUX keymap loader

# Load console keymap
if [ -f /usr/local/share/syscons/keymaps/baux.kbd ]; then
    kbdcontrol -l /usr/local/share/syscons/keymaps/baux.kbd
    echo "BAUX console keymap loaded"
elif [ -f /usr/share/syscons/keymaps/baux.kbd ]; then
    kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd
    echo "BAUX console keymap loaded"
else
    echo "BAUX keymap file not found!"
fi

# Load X11 keymap
if [ -f /usr/local/share/roxieos/xmodmap.rc ]; then
    xmodmap /usr/local/share/roxieos/xmodmap.rc
    echo "X11 keymap loaded"
fi
EOF

chmod +x /root/load_baux_keymap.sh

# Add to .bashrc for automatic loading
echo '/root/load_baux_keymap.sh' >> ~/.bashrc
```

Then run: `/root/load_baux_keymap.sh`

## Test After Fix

```bash
# Test console keymap
echo "Press Caps Lock - should act as Escape"
vim  # Should work with Caps Lock as Escape

# Test X11 keymap
xmodmap /usr/local/share/roxieos/xmodmap.rc
# Caps Lock should work as Escape in X applications
```

## Prevention for Future

Update the roxieos-base port to ensure keymap loading:

1. **Verify file installation** in debian/install
2. **Add rc.conf update** to post-install
3. **Add verification** that keymap loads
4. **Add emergency loader** as fallback

Let me know what the diagnostic commands show!</content>
<filePath>keymap-debug-steps.md