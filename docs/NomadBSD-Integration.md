# NomadBSD Integration Guide
**Incorporating Live USB Best Practices**

## Overview

RoxieOS adopts key technologies and approaches from NomadBSD, the leading FreeBSD-based live USB system. This document outlines the integrated features and current implementation status, with focus on local development before mesh expansion.

## Core Technologies Adopted

### 1. UnionFS-FUSE Persistence
**NomadBSD Approach:**
- Read-only base system with writable overlay using unionfs-fuse
- Prevents corruption of base image
- Allows unlimited persistence on any USB drive

**RoxieOS Status:** Planned for Phase 1 completion
**Current Implementation:**
```bash
# Phase 1: Basic persistence framework
# Phase 2: Full unionfs-fuse integration
# Phase 3: Mesh synchronization
```

**Benefits:**
- No base image corruption from system updates
- Works on any USB drive size
- Foundation for BAUX mesh persistence

### 2. Bootloader & UEFI Support
**NomadBSD Features:**
- Dual BIOS/UEFI support
- EFI framebuffer fixes for distorted screens
- Boot menu options for troubleshooting
- Graphics driver detection at boot

**RoxieOS Status:** In development for Phase 1
**Current Implementation:**
- Basic EFI support planned
- X200-specific bootloader configuration
- Graphics detection framework

### 3. Automatic Hardware Setup
**NomadBSD Hardware Detection:**
- Graphics: Intel, NVIDIA, AMD with VESA/SCFB fallback
- Sound: Pre-configured drivers with mixer
- Network: Wireless setup with NetworkMgr
- Input: Touchpad configuration

**RoxieOS Status:** Framework in development
**Current Implementation:**
- System probe script for hardware detection
- X200-specific configuration
- Foundation for auto-setup scripts

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

## Current Implementation Status

### Phase 1: Full -Dev Live USB (In Progress)
- **Foundation:** Basic BAUX packages for X200
- **Persistence:** unionfs-fuse framework
- **Integration:** X startup with session detection
- **Testing:** ThinkPad X200 compatibility

### Phase 2: Server-Only Derivation (Planned)
- **Extraction:** Server components from full system
- **Deployment:** Proxmox VM on LAN
- **Foundation:** LAN-based mesh preparation

### Phase 3: BAUX Mesh (Future)
- **Headscale:** Distributed authentication
- **Sync:** Cross-device session management
- **Cloud:** Remote server deployment

## BAUX Server Requirements

### Minimum Cloud VPS Specifications
Based on RackNerd Black Friday deals and BAUX server needs:

**Recommended: 1GB KVM VPS ($10.60/year)**
- **CPU:** 1 vCPU (sufficient for Headscale + session storage)
- **RAM:** 1GB (Headscale uses ~100MB, session DB minimal)
- **Storage:** 25GB SSD (session data, configs, logs)
- **Bandwidth:** 2000GB/month (adequate for mesh traffic)
- **OS:** FreeBSD 15.0 (custom ISO support available)

**Growth Option: 2.5GB KVM VPS ($18.66/year)**
- **CPU:** 2 vCPU (better for concurrent sessions)
- **RAM:** 2.5GB (headroom for monitoring/tools)
- **Storage:** 45GB SSD (more session history)
- **Bandwidth:** 3000GB/month (higher mesh activity)

### Server Software Stack
- **Headscale:** ~50MB RAM, lightweight Go application
- **Session Storage:** SQLite (minimal) or PostgreSQL (scalable)
- **Web Interface:** Optional for administration
- **Monitoring:** Basic resource monitoring

### Network Requirements
- **Inbound:** Headscale control plane (UDP/TCP ports)
- **Outbound:** Mesh connectivity to clients
- **DNS:** hs.coseismic.org domain for control plane

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
- **Mesh Networking:** Headscale-based distributed sessions

## References

- **FreeBSD Server Setup:** https://www.youtube.com/watch?v=r-qn6DrJ6IA
- **RackNerd VPS Plans:** https://www.racknerd.com/kvm-vps
- **Headscale Documentation:** https://headscale.net/

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

NomadBSD provides a proven foundation for FreeBSD live systems. RoxieOS builds upon this foundation with BAUX workstation cloning and mesh networking capabilities, creating a powerful combination of live persistence, session resurrection, and distributed computing.

**Current Focus:** Getting the full -dev environment working on ThinkPad X200 before expanding to mesh capabilities.

For detailed implementation, see the [NomadBSD Handbook](https://nomadbsd.org/handbook/handbook.html) and [GitHub repository](https://github.com/nomadbsd/NomadBSD).