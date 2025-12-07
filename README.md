# BAUXBSD - Instant Workstation Cloning OS
**Clone your workstation from USB in 5 seconds. Immortal sessions, zero friction.**

THIS IS NOT RELEASE SOFTWARE
Complete rewrite for maximum efficiency: Boot USB → Clone Environment → Productive.

## Core Philosophy

**Workstation Cloning**: Boot live USB on new laptop → Run clone script → Your exact sessions/projects restore instantly. No manual setup, no dotfile managers—just instant productivity.

- **No users, no sudo, no passwords** - Root everywhere
- **Caps Lock → Escape globally** - Muscle memory preserved
- **RAM-first operation** - Everything loads fast
- **Immortal sessions** - Survive reboots, machine swaps, crashes
- **Unified keybindings** - Same keys across console, tmux, WM, editor

## The Workstation Cloning Workflow

1. **Backup**: On current machine, run `baux-backup /path/to/usb` (saves sessions, projects, configs)
2. **Boot**: Insert USB into new laptop, boot live OS
3. **Clone**: Run `baux-clone /path/to/backup` (restores everything in <5 seconds)
4. **Work**: Sessions revive, projects sync, you're productive

## Package Layers for Cloning

| Layer | Package | Purpose | Size | When Used |
|--------|---------|-----------|-------|------------|
| 1 | bbase | System foundation + keymap | <50MB | Every clone |
| 2 | baux | Session cloning + tmux immortality | +80MB | Workstation core |
| 3 | bwm | Window manager for dev | +25MB | Dev machines |

## Core Packages for Workstation Cloning

### Essential (v0.1 - Clone-Ready)
1. **bbase** - Foundation: baux.kbd keymap, system tweaks
2. **baux** - Cloning: Session backup/restore, tmux resurrection
3. **bwm** - WM: dwm fork with BAUX keybindings
4. **bterm** - Terminal: st fork, BAUX-themed
5. **bvi** - Editor: Neovim wrapper with fallback, session integration
6. **bweb** - Browser: qutebrowser/surf, keyboard-native
7. **chaos** - Screensaver: Anti-burn-in for long sessions

### Dev Packages (-dev tier)
- **bview** - Image viewer (sxiv-based)
- **bmedia** - Media player (mpv wrapper)
- **bbot** - AI assistant with local models
- **bdrop** - SeaweedFS for full project syncing

## Key Features for Cloning

- **Unified Keymap**: Mod4+1-9 switches sessions everywhere (console→tmux→WM→editor)
- **Session Resurrection**: `baux revive --all` restores exact state from backup
- **Cross-Machine Sync**: Projects auto-sync between cloned workstations
- **Zero Intervention**: Dead panes revive on Enter, no manual restart
- **Anti-Nesting**: Smart SSH detection, no double-tmux

## Quick Workstation Cloning

```bash
# On current machine: Backup to USB
baux-backup /mnt/usb/backup

# Boot new laptop with BAUXBSD USB
dd if=BAUXBSD-15.0-RELEASE.iso of=/dev/sdb bs=1M

# On new machine: Install and clone
pkg install bbase baux bwm bterm bvi bweb chaos
baux-clone /mnt/usb/backup

# You're done - sessions appear:
# 1:shell  2:edit  3:web  4:project1  5:project2  6:——  7:——  8:——  9:——  15:33
```

## Documentation

- **[BAUXBSD.md](BAUXBSD.md)** - Technical manifesto
- **[ROADMAP.md](ROADMAP.md)** - Implementation roadmap
- **[PACKAGES.md](PACKAGES.md)** - Package structure
- **[INSTALL.md](INSTALL.md)** - Installation & cloning
- **[packages/keymap/KEYMAPS.md](packages/keymap/KEYMAPS.md)** - Keymap philosophy

## Design Principles

1. **Minimal footprint**: <400MB core for fast cloning
2. **Instant cloning**: <5 seconds to restored workstation
3. **Muscle memory**: Identical keybindings everywhere
4. **State immortality**: Sessions/projects survive everything
5. **Zero friction**: No dialogs, no manual config

---

Clone forever.
Sessions forever.
FreeBSD forever.

– badlandz, December 2025