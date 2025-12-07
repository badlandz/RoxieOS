# BAUXBSD Handbook
**GruvBAUX Prototype - FreeBSD-Based Workstation Cloning OS**

Version: GruvBAUX (Pre-v0.1)
Last Updated: December 2025

## Table of Contents

1. [Introduction](Introduction.md) - Philosophy and overview
2. [Installation](Installation.md) - Setup and cloning
3. [Packages](PACKAGES.md) - Package architecture
4. [Configuration](Configuration.md) - Keymaps and setup
5. [Usage](Usage.md) - Workflows and examples
6. [BAUX Session Management](BAUX-Session-Management.md) - Immortal sessions & resurrection
7. [BAUX Mesh Architecture](BAUX-Mesh-Architecture.md) - Distributed session networking
8. [BAUX Server Deployment](BAUX-Server-Deployment.md) - Headscale & cloud setup
9. [NomadBSD Integration](NomadBSD-Integration.md) - Live USB implementation
10. [Development](Development.md) - Roadmap and contributing
11. [FAQ](FAQ.md) - Common questions and troubleshooting

## Credits & Acknowledgments

RoxieOS builds upon the excellent work of:

- **[NomadBSD](https://nomadbsd.org)**: Live USB persistence with unionfs-fuse, bootloader/UEFI handling, automatic hardware setup, and Qt-based tools
- **[FreeBSD Project](https://www.freebsd.org/)**: The rock-solid foundation and comprehensive documentation
- **[Suckless Tools](https://suckless.org/)**: dwm, st, and dmenu inspiration for the BAUX window management layer

Special thanks to the NomadBSD team for pioneering FreeBSD live systems. Their [handbook](https://nomadbsd.org/handbook/handbook.html) and [GitHub repository](https://github.com/nomadbsd/NomadBSD) were invaluable references.

## Quick Start

**Workstation Cloning in 5 Steps:**

1. **Backup**: `baux-backup /mnt/usb/backup`
2. **Boot**: USB with FreeBSD 15.0 + BAUX packages
3. **Install**: `pkg install bbase baux bwm bterm bvi bweb chaos`
4. **Clone**: `baux-clone /mnt/usb/backup`
5. **Work**: Sessions restore instantly

## Core Principles

- **No users, no sudo, no passwords** - Root everywhere
- **Caps Lock → Escape globally** - Muscle memory preserved
- **Immortal sessions** - Survive everything
- **Unified keybindings** - Same keys across all layers
- **Gruvbox theming** - Consistent colors everywhere
- **Local-first mesh** - LAN-based session sharing
- **Zero friction** - Instant productivity

## Package Layers

| Layer | Package | Purpose | Size | Status |
|--------|---------|-----------|-------|--------|
| 1 | bbase | System foundation + keymap | <50MB | 🚧 In Development |
| 2 | baux | Local session management + tmux | +80MB | 🚧 In Development |
| 3 | bwm | Window manager for development | +25MB | 🚧 In Development |
| 4 | bvi | Neovim with BAUX integration | +90MB | ✅ Config Ready |
| 5 | bterm | Terminal with theming | +5MB | 🚧 Planned |
| 6 | chaos | Anti-burn-in screensaver | +1MB | 🚧 Planned |

## Key Features

- **Unified Keymap**: Mod4+1-9 switches sessions everywhere (planned)
- **Local Session Management**: tmux session persistence (in development)
- **Gruvbox Theming**: Consistent colors across all components
- **Live USB Ready**: unionfs-fuse persistence (planned)
- **X200 Optimized**: Primary test platform compatibility
- **FreeBSD Native**: Ports system, ZFS, rc.d services

## Directory Structure

```
RoxieOS/
├── src/          # FreeBSD kernel/userland patches (planned)
├── ports/        # BAUX package ports (in development)
├── patches/      # Upstream patches (dwm, st sources)
├── scripts/      # Build/install scripts + probe tool
├── docs/         # This handbook
├── neovim/       # Standalone neovim config (ready)
└── archive/      # Legacy Debian packages
```
RoxieOS/
├── src/          # FreeBSD src tree patches
├── ports/        # BAUX package ports
├── patches/      # Upstream patches
├── scripts/      # Build/install scripts
├── docs/         # This handbook
└── archive/      # Legacy Debian packages
```

## Getting Help

- See [FAQ](FAQ.md) for common issues
- Check [Usage](Usage.md) for workflows
- Review [Development](Development.md) for roadmap

---

**Root forever. Layers forever. FreeBSD forever.**

– badlandz, December 2025