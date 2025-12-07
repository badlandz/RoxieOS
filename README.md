# RoxieOS - GruvBAUX Prototype

**Clone your workstation from USB in 5 seconds. Immortal sessions, zero friction.**

*Codename: GruvBAUX - Unified Gruvbox theming across all layers*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FreeBSD](https://img.shields.io/badge/FreeBSD-15.0+-red.svg)](https://www.freebsd.org/)
[![GitHub issues](https://img.shields.io/github/issues/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/issues)
[![GitHub stars](https://img.shields.io/github/stars/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/stargazers)

## Overview

RoxieOS is a minimal FreeBSD-based operating system designed for instant workstation cloning and persistent development environments. Inspired by NomadBSD's live USB persistence approach, RoxieOS uses unionfs-fuse for read-only base systems with writable overlays. Boot from USB, clone your exact setup in seconds, and continue working seamlessly across any hardware.

**GruvBAUX Prototype**: This pre-v0.1 release features unified Gruvbox theming across console, dwm/bwm, neovim, tmux, and all BAUX components. Sessions become distributed network resources via Headscale mesh networking, accessible from any enrolled device.

![RoxieOS Screenshot](https://via.placeholder.com/800x400/000000/00FF00?text=RoxieOS+Screenshot+Coming+Soon)

## Key Features

- **Distributed Sessions**: Sessions as network resources via Headscale mesh
- **Workstation Cloning**: Backup and restore complete environments instantly
- **Immortal Sessions**: Sessions survive reboots, crashes, and hardware changes
- **Unified Keymaps**: Consistent controls across console, WM, editor, and terminal
- **Gruvbox Theming**: Cohesive visual experience across all components
- **FreeBSD Native**: Ports system, ZFS snapshots, rc.d services
- **Minimal Footprint**: Core packages <400MB, boot in <5 seconds

## Quick Start

### Prerequisites
- FreeBSD 15.0+ system (tested on ThinkPad X300)
- Basic FreeBSD knowledge

### Manual Installation (Current Method)
```bash
# Install FreeBSD 15.0 and basic dependencies
pkg update
pkg install bash git neovim tmux

# Clone and install BAUX
git clone https://github.com/badlandz/RoxieOS.git
cd RoxieOS

# Configure doas and install
echo "permit nopass :wheel" >> /usr/local/etc/doas.conf
./scripts/install-baux-unified.sh

# Start BAUX session
baux
```

### What You Get
- **Caps Lock → Escape** globally
- **baux** session manager with tmux
- **bvi** neovim wrapper with Gruvbox theme
- Immortal sessions with TPM resurrection
- Unified Gruvbox theming across all components

### 3. Boot and Install Packages
```bash
# Boot from USB, then install core packages
pkg update
pkg install bbase baux bwm bvi chaos
```

### 4. Clone and Configure
```bash
# Clone your workstation
baux-clone /mnt/usb/backup

# Enable services
echo 'baux_enable="YES"' >> /etc/rc.conf
echo 'bwm_enable="YES"' >> /etc/rc.conf

# Start working - sessions restore instantly!
baux
```

## Status

**Version:** GruvBAUX Prototype (Pre-v0.1)  
**Release:** Alpha  
**Target:** Full -dev live USB with local BAUX mesh foundation  
**Current Focus:** X300 ThinkPad compatibility and core component testing  
**✅ Completed:** bbase, baux, bvi FreeBSD ports with installation scripts

## Package Ecosystem

| Package | Purpose | Size | Status |
|---------|---------|------|--------|
| bbase | System foundation + keymap | <50MB | ✅ Core |
| baux | Session management | +80MB | ✅ Core |
| bwm | Window manager (dwm fork) | +25MB | ✅ Core |
| bterm | Terminal (st fork) | +5MB | 🚧 Planned |
| bvi | Editor (neovim wrapper) | +90MB | ✅ Core |
| bweb | Browser (keyboard-native) | +40MB | 🚧 Planned |
| chaos | Anti-burn-in screensaver | +1MB | ✅ Core |

### Development Packages
- bview: Image viewer
- bmedia: Media player
- bbot: AI assistant
- bdrop: SeaweedFS persistence

## Architecture

```
RoxieOS/
├── src/          # FreeBSD kernel/userland patches
├── ports/        # BAUX package ports
├── patches/      # Upstream patches (dwm, st, etc.)
├── scripts/      # Build and install automation
├── docs/         # Handbook-style documentation
└── neovim/       # Standalone neovim config
```

## Documentation

- **[Handbook](docs/Handbook.md)**: Complete user guide
- **[Installation](docs/Installation.md)**: Setup and cloning
- **[Configuration](docs/Configuration.md)**: Keymaps and setup
- **[BAUX Session Management](docs/BAUX-Session-Management.md)**: Immortal sessions explained
- **[BAUX Mesh Architecture](docs/BAUX-Mesh-Architecture.md)**: Distributed networking
- **[BAUX Server Deployment](docs/BAUX-Server-Deployment.md)**: Headscale setup guide
- **[NomadBSD Integration](docs/NomadBSD-Integration.md)**: Live USB implementation
- **[Development](docs/Development.md)**: Roadmap and contributing

## Philosophy

**One Finger Movement = One Meaning**

RoxieOS eliminates friction in development workflows:
- Caps Lock → Escape globally
- Mod4+1-9 switches sessions everywhere
- hjkl navigation in all contexts
- Sessions persist across any interruption
- **Gruvbox theming**: Unified colors across console, WM, editor, and terminal

## Requirements

**Client (Workstation):**
- FreeBSD 15.0+
- ZFS filesystem
- USB boot capability
- 512MB RAM minimum (Pi Zero compatible)

**Server (Cloud/LAN):**
- FreeBSD 15.0+ VPS (RackNerd $10.60/year recommended)
- 1GB RAM, 1 vCPU, 25GB SSD minimum
- Domain for Headscale (hs.coseismic.org)
- Reference: [FreeBSD Server Setup](https://www.youtube.com/watch?v=r-qn6DrJ6IA)

## Roadmap

### Phase 1: Full -Dev Live USB (Current - 2-3 weeks)
**Goal:** Bootable USB with complete BAUX environment on X200**
- ✅ FreeBSD ports migration
- ✅ Workstation cloning foundation
- ✅ BAUX session management (local)
- ✅ Unified keymap system
- ✅ Gruvbox theming across all layers
- 🚧 Live USB persistence (unionfs-fuse)
- 🚧 X startup integration
- 🚧 Full package ecosystem

### Phase 2: Server-Only Derivation (1-2 weeks)
**Goal:** Extract BAUX server from full system**
- Server-only package creation
- Proxmox VM deployment
- Local LAN mesh foundation
- Headscale preparation

### Phase 3: BAUX Mesh (1-2 weeks)
**Goal:** Distributed session management**
- Headscale server deployment ($10.60/year RackNerd VPS)
- Device enrollment and mesh networking
- Cross-device session sync and migration
- Full mesh authentication and ACLs

### Future: v0.1 Production (Q1 2026)
- Qt-based installer
- Hardware auto-detection
- Production ISO release
- Multi-platform support

See [Development Guide](docs/Development.md) for detailed roadmap.

## Testing BAUX on Your X300

### Quick Start for X300 Testing
```bash
# On your X300 FreeBSD system
git clone https://github.com/badlandz/RoxieOS.git
cd RoxieOS

# Check system compatibility
./scripts/baux-probe.sh

# Install core BAUX components
./scripts/install-baux-manual.sh

# Test everything works
./scripts/test-baux.sh

# Try BAUX!
baux
```

### What Should Work After Installation
- **Caps Lock → Escape** globally (bbase)
- **baux command** starts tmux session with custom config
- **bvi filename** opens files with neovim (or vim/vi fallback)
- **Gruvbox theming** in all components

### Current Test Platforms
- **Primary:** ThinkPad X300 (FreeBSD 15.0) - Your test system
- **Secondary:** Proxmox VM (FreeBSD 15.x) for server testing
- **Future:** Raspberry Pi, generic laptops

### Troubleshooting
If components don't work:
1. Check `./scripts/test-baux.sh` output for specific failures
2. Verify FreeBSD version: `freebsd-version` (needs 15.x)
3. Check dependencies: `pkg info tmux neovim`
4. Review installation logs for errors

### Reporting Issues
When reporting bugs, include the probe report and specify your platform.

## Contributing

We welcome contributions! See [Development Guide](docs/Development.md) for:

- Building from source
- Package development
- Testing guidelines
- Code style

### Getting Help

- 📖 [Handbook](docs/Handbook.md) - Complete documentation
- 🐛 [Issues](https://github.com/badlandz/RoxieOS/issues) - Bug reports
- 💬 [Discussions](https://github.com/badlandz/RoxieOS/discussions) - Q&A

## License

MIT License - see [LICENSE](LICENSE) for details.

## Credits & Inspiration

- **NomadBSD**: Live USB persistence, bootloader/UEFI handling, automatic hardware setup, Qt installer
- **FreeBSD Handbook**: Documentation structure and best practices
- **Suckless Tools**: dwm, st, dmenu inspiration for bwm, bterm
- **FreeBSD Server Setup**: https://www.youtube.com/watch?v=r-qn6DrJ6IA (cloud deployment reference)

See [NomadBSD Handbook](https://nomadbsd.org/handbook/handbook.html) for detailed implementation of live systems.

## Repository Status

- **Status**: Active Development
- **Version**: GruvBAUX Prototype (Pre-v0.1)
- **License**: MIT
- **Issues**: [GitHub Issues](https://github.com/badlandz/RoxieOS/issues)
- **Discussions**: [GitHub Discussions](https://github.com/badlandz/RoxieOS/discussions)

---

**Root forever. Layers forever. FreeBSD forever.**

– badlandz, December 2025