# RoxieOS Directory Restructure Plan: FreeBSD Source Tree & Live Patching

## Overview
Current layout is Debian-focused (debian/ subdirs, .deb packaging), unsuitable for FreeBSD development. This plan restructures for FreeBSD's src tree (kernel/userland patches), ports (packaging), and live upstream patching. Enables efficient FreeBSD development, workstation cloning, and BAUXBSD integration.

## Current Issues
- Debian bias: packages/ with debian/ for apt builds, not FreeBSD ports.
- Scattered sources: dwm source in bwm/dwm/, patches in patches/.
- No src tree: Missing /usr/src mirroring for kernel/userland patches.
- Live patching: No workflow for pulling upstream (e.g., suckless/dwm) and applying BAUX mods.

## Proposed New Layout
```
referance/RoxieOS/
├── src/                          # FreeBSD src tree patches (kernel, userland)
│   ├── sys/                      # Kernel patches (e.g., BAUX keymap in console)
│   ├── usr.bin/                  # Userland tools (e.g., tmux with BAUX mods)
│   ├── patches/                  # Diffs for /usr/src
│   └── upstream/                 # Git submodules for live upstream pulls
├── ports/                        # FreeBSD ports for BAUX packages
│   ├── baux-base/                # Port for bbase (keymap, foundation)
│   ├── baux-shell/               # Port for baux (tmux session mgmt)
│   ├── baux-wm/                  # Port for bwm (dwm fork)
│   ├── baux-vi/                  # Port for bvi (editor wrapper)
│   └── Makefile                  # Ports build scripts
├── patches/                      # Live upstream patches (e.g., dwm mods)
│   ├── dwm-roxanne.patch         # From current bwm/patches/
│   ├── tmux-baux.patch           # New for tmux enhancements
│   └── upstream-sources/         # Git clones for patching (suckless dwm, tmux)
├── scripts/                      # Build/install scripts for FreeBSD
│   ├── build-src.sh              # Patch /usr/src and build world
│   ├── build-ports.sh            # Build custom ports
│   ├── install-live.sh           # Pull upstream, patch, install
│   └── clone-workstation.sh      # Workstation cloning script
├── packages/                     # Legacy Debian packages (move to archive/)
│   └── archive/                  # Old debian/ stuff
└── docs/                         # Updated docs (README, ROADMAP)
```

## Key Changes Explained
- **src/**: Mirrors FreeBSD /usr/src for patches (e.g., add BAUX keymap to sys/dev/kbd).
- **ports/**: FreeBSD ports structure (Makefile, distinfo) instead of Debian debhelper.
- **patches/**: Centralized for live upstream (git submodules for suckless/dwm, apply BAUX patches).
- **scripts/**: Automate FreeBSD workflows (e.g., `make buildworld` after src patches).
- **Archive Debian**: Move debian/ to packages/archive/ for legacy reference.

## Implementation Steps
1. **Backup Current**: Copy RoxieOS/ to RoxieOS-backup/.
2. **Create Structure**: Mk dirs, move files (e.g., bwm/dwm/ to patches/upstream/).
3. **Add FreeBSD Elements**: Populate src/ with FreeBSD src mirrors, ports/ with Makefiles.
4. **Submodules**: Add git submodules for upstream (e.g., suckless/dwm).
5. **Scripts**: Write build/install scripts.
6. **Test**: Patch dwm, build port on FreeBSD VM.

## Scope Assumptions
- Focus on bwm (dwm), bvi (editor), baux (tmux) for initial restructure.
- Kernel patches for BAUX keymap in src/sys/.
- Workstation cloning integrates via scripts/clone-workstation.sh.

## Open Questions
- FreeBSD components to patch (kernel keymap, tmux userland, dwm ports)?
- Upstream pulls: dwm, tmux, neovim—how to apply BAUX patches?
- Ports vs. src: Keep bwm as port or move to src?
- Cloning: Backup src/ports/ changes to USB?
- Dual support: Keep Debian for compatibility?

This plan shifts from Debian packaging to FreeBSD src/ports/patching for better development efficiency.