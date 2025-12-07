# BAUXBSD Handbook
**FreeBSD-Based Workstation Cloning OS**

Version: v0.1 (Development)
Last Updated: December 2025

## Table of Contents

1. [Introduction](Introduction.md) - Philosophy and overview
2. [Installation](Installation.md) - Workstation cloning setup
3. [Packages](PACKAGES.md) - Package architecture and ports
4. [Configuration](Configuration.md) - Keymaps and system setup
5. [Usage](Usage.md) - Daily workflows and examples
6. [Development](Development.md) - Roadmap and contribution
7. [FAQ](FAQ.md) - Common questions and troubleshooting

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
- **Zero friction** - Instant productivity

## Package Layers

| Layer | Package | Purpose | Size |
|--------|---------|-----------|-------|
| 1 | bbase | System foundation + keymap | <50MB |
| 2 | baux | Session cloning + tmux immortality | +80MB |
| 3 | bwm | Window manager for development | +25MB |

## Key Features

- **Unified Keymap**: Mod4+1-9 switches sessions everywhere
- **Session Resurrection**: Exact state restoration
- **Cross-Machine Sync**: Projects auto-sync
- **Anti-Nesting**: Smart SSH detection
- **FreeBSD Native**: Ports system, ZFS, rc.d services

## Directory Structure

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