# BAUXBSD Changelog

## GruvBAUX Prototype (Pre-v0.1) - December 2025

### Major Changes
- **FreeBSD Migration**: Complete restructure from Debian to FreeBSD ports/src model
- **Directory Reorganization**: New layout with src/, ports/, patches/, scripts/, docs/, archive/
- **Package Renaming**: keymap → bbase, consistent b* naming (baux, bwm, bterm, bvi)
- **Unified Gruvbox Theming**: Gruvbox colors across console, dwm/bwm, neovim, tmux, and all components
- **Documentation Overhaul**: FreeBSD handbook-style structure with cross-references
- **NomadBSD Integration**: Adopted unionfs-fuse persistence, bootloader/UEFI handling, automatic hardware setup

### New Features
- **bbase**: System foundation with global Caps→Esc keymap
- **baux**: Immortal tmux sessions with resurrection
- **bwm**: dwm fork with BAUX session integration
- **bterm**: st fork with BAUX theming (placeholder)
- **chaos**: Anti-burn-in screensaver
- **Workstation Cloning**: Backup/restore workflow

### Infrastructure
- **Build Scripts**: build-src.sh, build-ports.sh, install-live.sh, clone-workstation.sh
- **Port Structure**: FreeBSD ports for all BAUX packages
- **Patch Management**: Centralized upstream patches in patches/upstream/
- **Archive**: Legacy Debian packages preserved for reference

### Documentation
- **Handbook Structure**: Introduction, Installation, Packages, Configuration, Usage, Development, FAQ
- **Cross-References**: Consistent linking between sections
- **FreeBSD Style**: Comprehensive, structured, example-rich

## Future Releases

### v0.2 - Extended Persistence
- Full SeaweedFS implementation in bdrop
- Cross-machine session synchronization
- PostgreSQL knowledge base integration
- Performance optimizations

### v1.0 - Complete Vision
- AI-powered development environment
- Automatic project resurrection
- Full digital twin implementation
- Static binary distributions

---

See Development.md for detailed roadmap.