# NomadBSD Integration Guide
**Incorporating Live USB Best Practices**

## Overview

RoxieOS adopts key technologies and approaches from NomadBSD, the leading FreeBSD-based live USB system. This document outlines the integrated features and implementation details.

## Core Technologies Adopted

### 1. UnionFS-FUSE Persistence
**NomadBSD Approach:**
- Read-only base system with writable overlay using unionfs-fuse
- Prevents corruption of base image
- Allows unlimited persistence on any USB drive

**RoxieOS Implementation:**
```bash
# Base system: Read-only ISO
# Overlay: Writable partition for user data
# Union: FUSE-based merge for seamless operation
```

**Benefits:**
- No base image corruption from system updates
- Works on any USB drive size
- Automatic filesystem expansion on first boot

### 2. Bootloader & UEFI Support
**NomadBSD Features:**
- Dual BIOS/UEFI support
- EFI framebuffer fixes for distorted screens
- Boot menu options for troubleshooting
- Graphics driver detection at boot

**RoxieOS Integration:**
- Custom bootloader with EFI support
- Boot menu options:
  - Disable graphics detection
  - Disable syscons
  - Set GOP mode for EFI
- Automatic graphics driver setup

### 3. Automatic Hardware Setup
**NomadBSD Hardware Detection:**
- Graphics: Intel, NVIDIA, AMD with VESA/SCFB fallback
- Sound: Pre-configured drivers with mixer
- Network: Wireless setup with NetworkMgr
- Input: Touchpad configuration

**RoxieOS Adoption:**
- Graphics driver auto-detection scripts
- DSBMixer for sound control
- NetworkMgr for wireless management
- Touchpad configuration tools

### 4. Qt-Based Installer
**NomadBSD Installer:**
- GUI installer for hard disk deployment
- Supports ZFS and UFS
- User-friendly interface

**RoxieOS Plans:**
- Qt-based installer for persistent USB setup
- Hard disk installation option
- ZFS/UFS filesystem choices
- Gruvbox-themed interface

## Implementation Details

### Filesystem Layout
```
NomadBSD/RoxieOS Layout:
├── base.ufs (read-only) - Base system
├── overlay.ufs (read-write) - User data
└── unionfs-fuse - Runtime merge
```

### Boot Process
1. **BIOS/UEFI Detection:** Choose appropriate bootloader
2. **Graphics Setup:** Auto-detect and load drivers
3. **Filesystem Mount:** UnionFS overlay creation
4. **System Start:** Normal FreeBSD boot with persistence

### Hardware Setup Scripts
- `initgfx`: Graphics driver detection and setup
- `dsbmc`: Device mounting and management
- `networkmgr`: Wireless network configuration
- `dsbmixer`: Audio device control

## Configuration Files

### Bootloader Settings
```bash
# /boot/loader.conf
vfs.root_mount_always_wait=1  # Wait for USB devices
kern.vt.fb.default_mode="1024x768"  # EFI framebuffer mode
```

### RC Scripts
```bash
# /etc/rc.conf additions
unionfs_enable="YES"
dsbmd_enable="YES"
initgfx_enable="YES"
```

## Troubleshooting (NomadBSD Reference)

### Boot Issues
- **Mountroot prompt:** Use USB 2.0 port or add `vfs.root_mount_always_wait=1`
- **EFI distortion:** Set GOP mode in loader: `gop set 0`
- **Graphics crash:** Disable auto-detection in boot menu

### Hardware Problems
- **NVIDIA issues:** Add `hw.nvidia.registered=1` to loader.conf
- **Touchpad failure:** Adjust `kern.evdev.rcpt_mask`
- **Sound defaults:** Use DSBMixer to set default device

## Development References

### NomadBSD Handbook Sections
- [Installation](https://nomadbsd.org/handbook/handbook.html#installation)
- [Filesystem](https://nomadbsd.org/handbook/handbook.html#filesystems)
- [Networking](https://nomadbsd.org/handbook/handbook.html#networking)
- [Troubleshooting](https://nomadbsd.org/handbook/handbook.html#troubleshooting)

### GitHub Resources
- [Build Scripts](https://github.com/nomadbsd/NomadBSD/tree/master/src)
- [Configuration](https://github.com/nomadbsd/NomadBSD/tree/master/config)
- [Patches](https://github.com/nomadbsd/NomadBSD/tree/master/patch)

## Future Enhancements

### Planned Adoptions
- **ZFS Support:** Full ZFS pool management for live systems
- **Multi-Head Graphics:** Advanced display configuration
- **Linux Binary Compatibility:** Enhanced browser support
- **Backup/Restore:** System state snapshots

### RoxieOS Extensions
- **BAUX Integration:** Session persistence with unionfs
- **Workstation Cloning:** Enhanced backup/restore over USB
- **Unified Keymaps:** BAUX system integration

## Building with NomadBSD Tools

RoxieOS can leverage NomadBSD's build infrastructure:

```bash
# Clone and build (adapted for RoxieOS)
git clone --recursive https://github.com/nomadbsd/NomadBSD.git
cd NomadBSD
# Modify build.cfg for RoxieOS packages
./build all
```

## Conclusion

NomadBSD provides a proven foundation for FreeBSD live systems. RoxieOS builds upon this foundation with BAUX workstation cloning capabilities, creating a powerful combination of live persistence and session resurrection.

For detailed implementation, see the [NomadBSD Handbook](https://nomadbsd.org/handbook/handbook.html) and [GitHub repository](https://github.com/nomadbsd/NomadBSD).