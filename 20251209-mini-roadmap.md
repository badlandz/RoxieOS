## Live USB Build: Installer Fixes Required

**Critical discoveries from Xorg/bwm debugging that MUST be addressed in the live USB installer**

### **bbase Component Missing from Installer**
**Issue:** Main `install.sh` doesn't include `bbase` in workstation dependencies
**Impact:** Console unusable for visually impaired users, keyboard mapping broken
**Required Fix:** Add `bbase` to `PORT_DEPENDENCIES["workstation"]` array
**Test:** `baux.kbd` installed, console fonts readable, Caps→Escape working

### **Xorg Configuration Issues**
**Issue:** Explicit InputDevice sections in xorg.conf interfere with libinput auto-detection
**Impact:** Keyboard/mouse don't work in X sessions
**Required Fix:** Use minimal xorg.conf (Device + Screen only), let libinput handle input
**Test:** Xorg starts with working keyboard/mouse input

### **GPU Driver Conflicts**
**Issue:** AMD/Intel GPU drivers conflict when both loaded
**Impact:** Xorg fails with "no screens found" error
**Required Fix:** Detect GPU type, load only appropriate driver (amdgpu OR i915kms)
**Test:** Xorg finds graphics hardware, DRI devices available

### **Build Script Cross-Platform Issues**
**Issue:** Build scripts use Linux paths/commands instead of FreeBSD equivalents
**Examples:**
- `sudo` → `doas`
- `/usr/X11R6/` → `/usr/local/`
- `#!/bin/sh` → `#!/usr/local/bin/bash`
**Required Fix:** Update all build scripts for FreeBSD compatibility
**Test:** `build-bwm-simple.sh` runs successfully on FreeBSD

### **Package Dependencies**
**Issue:** Build scripts don't declare required packages
**Impact:** Silent failures when dependencies missing
**Required Fix:** Add package installation checks to build scripts
**Test:** All required packages (xorgproto, libX11, etc.) installed automatically

### **Font Accessibility**
**Issue:** No high-DPI font configuration for visually impaired users
**Impact:** Unreadable text in terminals and applications
**Required Fix:** Automated `.Xresources` and console font setup
**Test:** 20pt+ fonts, high contrast, proper scaling

### **Terminal Integration**
**Issue:** bwm configured for mate-terminal but package not installed
**Impact:** Alt+Shift+Return keybinding fails
**Required Fix:** Include mate-terminal in workstation package set
**Test:** Alt+Shift+Return launches readable terminal

### **Keyboard Mapping**
**Issue:** Console keymap works but X session lacks mappings
**Impact:** Inconsistent keyboard behavior
**Required Fix:** Automated `.Xmodmap` creation for X sessions
**Test:** Caps Lock acts as Escape in both console and X

### **Testing Checklist for Live USB**
- [ ] Fresh FreeBSD install
- [ ] Run `./install.sh` (no manual fixes required)
- [ ] `startx` launches bwm successfully
- [ ] Keyboard/mouse work in X session
- [ ] Fonts readable (20pt+)
- [ ] Alt+Shift+Return opens terminal
- [ ] Caps Lock = Escape globally
- [ ] `baux` commands functional
- [ ] Session switching works

### **Implementation Priority**
1. **High:** bbase inclusion, Xorg minimal config, GPU detection
2. **Medium:** Build script fixes, package dependencies
3. **Low:** Font accessibility, keyboard mapping, terminal integration

**These fixes are critical for the "Live USB to IDE in 10 seconds" vision - without them, users get broken systems requiring extensive manual fixes.**</content>
<filePath>20251209-mini-roadmap.md