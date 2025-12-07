# RoxieOS - Instant Workstation Cloning OS

**Clone your workstation from USB in 5 seconds. Immortal sessions, zero friction.**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![FreeBSD](https://img.shields.io/badge/FreeBSD-15.0+-red.svg)](https://www.freebsd.org/)

## Overview

RoxieOS is a minimal FreeBSD-based operating system designed for instant workstation cloning and persistent development environments. Boot from USB, clone your exact setup in seconds, and continue working seamlessly across any hardware.

## Key Features

- **Workstation Cloning**: Backup and restore complete environments instantly
- **Immortal Sessions**: Sessions survive reboots, crashes, and hardware changes
- **Unified Keymaps**: Consistent controls across console, WM, editor, and terminal
- **FreeBSD Native**: Ports system, ZFS snapshots, rc.d services
- **Minimal Footprint**: Core packages <400MB, boot in <5 seconds

## Quick Start

### 1. Backup Your Workstation
```bash
baux-backup /mnt/usb/backup
```

### 2. Boot New Hardware
Download FreeBSD 15.0-RELEASE, boot from USB.

### 3. Install RoxieOS Packages
```bash
pkg install bbase baux bwm bterm bvi bweb chaos
```

### 4. Clone and Work
```bash
baux-clone /mnt/usb/backup
# Sessions restore instantly - you're productive immediately
```

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
- **[Configuration](docs/Configuration.md)**: Keymaps and customization
- **[Development](docs/Development.md)**: Roadmap and contributing

## Philosophy

**One Finger Movement = One Meaning**

RoxieOS eliminates friction in development workflows:
- Caps Lock → Escape globally
- Mod4+1-9 switches sessions everywhere
- hjkl navigation in all contexts
- Sessions persist across any interruption

## Requirements

- FreeBSD 15.0+
- ZFS filesystem
- USB boot capability
- 512MB RAM minimum (Pi Zero compatible)

## Contributing

See [Development Guide](docs/Development.md) for roadmap, building, and contribution guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.

---

**Root forever. Layers forever. FreeBSD forever.**

– badlandz, December 2025