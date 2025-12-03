# BAUXBSD - Minimal Cyberdeck OS
**Instant productivity, persistent sessions, zero friction**

THIS IS NOT RELEASE SOFTWARE
This is a complete rewrite from Debian to FreeBSD for maximum efficiency and minimalism.

## Core Philosophy

Boot USB → you are root → instant productivity in 5 seconds.

- **No users, no sudo, no passwords**
- **Caps Lock is dead, Escape lives there now**  
- **Everything runs in RAM by default**
- **Immortal sessions** that survive reboots and machine swaps
- **Unified keybindings** across console, tmux, window manager, and editor

## The Three Layers

| Layer | Name | Purpose | Size | Target Hardware |
|--------|------|-----------|-------|-----------------|
| 1 | baux-base | System foundation + keymap | <50MB | Any machine |
| 2 | baux | Shell/session manager | +80MB | Every machine you touch |
| 3 | bwm | Window manager | +25MB | Development machines |

## Package Architecture

### Core Packages (v0.1 Essential)

1. **baux-base** - System foundation with baux.kbd keymap
2. **baux** - Immortal shell with tmux session management
3. **bwm** - Minimal window manager (dwm fork)
4. **bterm** - BAUX-themed terminal (st fork)
5. **bvi** - Editor wrapper with intelligent fallback
6. **bweb** - Keyboard-native browser (qutebrowser/surf)
7. **chaos** - Anti-burn-in screensaver

### Optional Packages (-dev tier)

- **bview** - Image viewer (sxiv-based)
- **bmedia** - Media player (mpv wrapper)
- **bbot** - AI assistant with local models
- **bdrop** - Full SeaweedFS session persistence

## Key Features

- **Unified Keymap**: Mod4+1-9 switches sessions everywhere
- **Session Resurrection**: `baux revive --all` restores exact state
- **Cross-Machine Sync**: Projects sync between BAUX instances
- **Zero Intervention**: Dead panes auto-revive on Enter
- **Anti-Nesting**: Smart detection for SSH environments

## Quick Start

```bash
# Create bootable USB
dd if=BAUXBSD-15.0-RELEASE.iso of=/dev/da0 bs=1M

# Boot and install core
pkg install baux-base baux bwm bterm bvi bweb chaos

# Start BAUX environment
baux

# Your session appears:
# 1:shell  2:edit  3:web  4:——  5:——  6:——  7:——  8:——  9:——          15:33
```

## Documentation

- **[BAUXBSD.md](BAUXBSD.md)** - Complete technical manifesto
- **[ROADMAP.md](ROADMAP.md)** - FreeBSD implementation roadmap
- **[PACKAGES.md](PACKAGES.md)** - Package structure guide
- **[INSTALL.md](INSTALL.md)** - Installation and usage
- **[packages/keymap/KEYMAPS.md](packages/keymap/KEYMAPS.md)** - Unified keymap philosophy

## Design Principles

1. **Minimal footprint**: <400MB total core installation
2. **Instant boot**: <5 seconds to productive environment
3. **Muscle memory**: Same keybindings everywhere
4. **State persistence**: Sessions survive anything
5. **Zero friction**: No setup, no configuration dialogs

---

Root forever.
Layers forever.  
FreeBSD forever.

– badlandz, December 2025


