# BAUXBSD Critical Bug Report & Workaround Documentation

## Executive Summary

**Project Goal**: "Live USB stick to Tmux/neovim IDE in 10 seconds"
**Current Reality**: Complex installation requiring multiple workarounds, manual fixes, and unsustainable hacks
**Critical Issue**: Development pipeline creates unmaintainable code that prevents proper installer creation

## Major Bug Categories

### 1. **Installer Architecture Flaws**

#### **Missing Core Components**
- **Issue**: Main `install.sh` doesn't include `bbase` in workstation dependencies
- **Impact**: Console unusable for visually impaired users, keyboard mapping broken
- **Workaround**: Manual `bbase` installation required post-install
- **Fix Required**: Add `bbase` to `PORT_DEPENDENCIES["workstation"]`

#### **Privilege Escalation Failures**
- **Issue**: `doas` commands fail intermittently during install
- **Impact**: Components appear installed but aren't actually functional
- **Workaround**: Manual `doas` commands post-install
- **Root Cause**: User context issues, permission timing

#### **Deployment Type Detection**
- **Issue**: Auto-detection unreliable, manual override required
- **Impact**: Wrong components installed for hardware
- **Workaround**: `BAUX_DEPLOYMENT_TYPE=workstation ./install.sh`

### 2. **Xorg & Graphics Stack Issues**

#### **Input Device Conflicts**
- **Issue**: Xorg detects input devices but immediately unloads libinput modules
- **Symptoms**:
  - Keyboard works in console, dead in X
  - Mouse cursor doesn't move in X
  - `startx` works initially but input fails after Cinnamon install
- **Workaround**: Explicit `InputDevice` sections in `xorg.conf` (conflicts with auto-detection)
- **Hardware Context**: AMD Cezanne GPU + USB peripherals

#### **GPU Driver Conflicts**
- **Issue**: Both Intel and AMD drivers loaded simultaneously
- **Impact**: Graphics acceleration issues, input detection problems
- **Workaround**: `kldunload i915kms` to disable Intel driver
- **Fix Required**: BIOS-level GPU selection or better driver detection

#### **Xorg Configuration Inconsistencies**
- **Issue**: Minimal `xorg.conf` works on some systems, explicit config required on others
- **Impact**: Per-system configuration requirements
- **Workaround**: Trial-and-error xorg.conf modifications

### 3. **Build System Problems**

#### **Cross-Platform Path Issues**
- **Issue**: Linux paths hardcoded in FreeBSD build scripts
- **Examples**:
  - `sudo` instead of `doas`
  - `/usr/X11R6/` instead of `/usr/local/`
  - `#!/bin/sh` instead of `#!/usr/local/bin/bash`
- **Impact**: Build scripts fail on target platform
- **Workaround**: Manual script fixes during development

#### **Dependency Management**
- **Issue**: Build dependencies not properly declared
- **Impact**: Silent failures when packages missing
- **Workaround**: Manual `pkg install` commands

#### **Context-Sensitive Builds**
- **Issue**: Scripts assume run from specific directory as specific user
- **Impact**: Fail when run via `doas` or from different locations
- **Workaround**: Hardcoded paths and manual execution

### 4. **Console & Accessibility Issues**

#### **Keymap Application**
- **Issue**: `baux.kbd` installed but not applied after reboot
- **Impact**: Caps→Esc mapping not active
- **Workaround**: Manual `kbdcontrol -l` commands
- **Root Cause**: rc.conf vs immediate application conflicts

#### **Font Scaling**
- **Issue**: Console fonts too small, X11 fonts not scaled
- **Impact**: Unreadable for visually impaired users
- **Workaround**: Manual `vidcontrol` and `.Xresources` configuration
- **Fix Required**: Automated accessibility setup

### 5. **Development Pipeline Issues**

#### **Multi-System Synchronization**
- **Issue**: Code changes across .90 (Debian), .101 (FreeBSD workstation), .133 (FreeBSD laptop), cloud server
- **Impact**: Merge conflicts, lost changes, inconsistent states
- **Workaround**: Manual git operations, rollback points
- **Fix Required**: Centralized development workflow

#### **Testing Environment Mismatch**
- **Issue**: Development on Debian, deployment on FreeBSD
- **Impact**: Linux assumptions baked into FreeBSD code
- **Workaround**: Dual-environment awareness, manual translations
- **Fix Required**: Containerized FreeBSD development environment

## Current Workaround Checklist

### **Fresh FreeBSD Installation**
```bash
# 1. Install base system
# 2. Add user to wheel, video groups
pw groupmod video -m username

# 3. Install Xorg and graphics
pkg install xorg drm-kmod
sysrc kld_list+=amdgpu  # For AMD GPUs

# 4. Manual bbase installation (MISSING FROM INSTALLER)
cd /path/to/roxieos/ports/bbase
doas ./install.sh

# 5. Fix bwm build script (BROKEN IN SOURCE)
# Edit build-bwm-simple.sh:
# - Change #!/bin/sh to #!/usr/local/bin/bash
# - Change sudo to doas
# - Update X11 paths to /usr/local/

# 6. Install bwm
cd /path/to/roxieos
doas ./build-bwm-simple.sh

# 7. Configure Xorg (trial and error)
# Minimal xorg.conf for some systems, explicit InputDevice for others

# 8. Manual font setup
doas sysrc allscreens_flags="-f cp437-8x16"
echo "Xft.dpi: 192" >> ~/.Xresources

# 9. Handle GPU conflicts
kldunload i915kms  # If Intel driver conflicts
```

### **Xorg Debugging Steps**
```bash
# Check input devices
ls /dev/input/
dmesg | grep -i usb

# Check Xorg log
tail /var/log/Xorg.0.log

# Test different xorg.conf configurations
# Try minimal, then explicit InputDevice sections

# Check GPU drivers
kldstat | grep -E '(amdgpu|i915)'

# Test with different window managers
# bwm vs cinnamon vs twm
```

## Architectural Problems

### **Component Coupling**
- **Issue**: Ports depend on each other in undocumented ways
- **Example**: bwm requires specific Xorg configuration, fonts require bbase
- **Impact**: Installation order matters, failures cascade

### **Configuration Drift**
- **Issue**: Per-system configuration requirements
- **Impact**: No "works everywhere" installer possible
- **Root Cause**: Hardware diversity without abstraction layer

### **Error Handling**
- **Issue**: Silent failures, no rollback mechanisms
- **Impact**: Partially broken systems appear working
- **Fix Required**: Comprehensive error checking and recovery

## Roadmap Impact

### **Live USB Goal Compromised**
- **Current State**: Requires 50+ manual steps, multiple reboots
- **Target**: "10 seconds to IDE"
- **Gap**: 2-3 orders of magnitude from goal

### **Maintainability Crisis**
- **Issue**: Workarounds accumulate, creating technical debt
- **Impact**: Each "fix" makes proper solution harder
- **Solution Needed**: Clean architecture reset

## Immediate Action Items

### **High Priority**
1. **Fix installer** to include all required components
2. **Standardize Xorg configuration** across hardware
3. **Implement proper error handling** in build scripts
4. **Create hardware abstraction layer** for GPU/input detection

### **Medium Priority**
1. **Document all workarounds** (this document)
2. **Create rollback mechanisms** for failed installs
3. **Implement automated testing** for installations
4. **Design proper development workflow**

### **Long Term**
1. **Architecture redesign** for maintainable installer
2. **Hardware abstraction** for universal compatibility
3. **Containerized development** environment
4. **Automated deployment** pipeline

## Success Criteria

### **Installation Success**
- ✅ Zero manual steps required
- ✅ Works on all supported hardware
- ✅ Proper error messages and recovery
- ✅ Accessibility features automatic

### **Development Success**
- ✅ Single source of truth
- ✅ Automated testing
- ✅ Rollback capabilities
- ✅ Cross-platform compatibility

## Conclusion

The current state demonstrates a working prototype but an unsustainable development approach. The accumulation of workarounds prevents achieving the "Live USB to IDE in 10 seconds" vision. A clean architectural reset is required to build a maintainable, deployable system.

**Status**: Prototype functional with extensive manual intervention required.
**Next Step**: Architectural redesign for maintainable installer.</content>
<filePath>BUG_REPORT.md