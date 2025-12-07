# BAUXBSD Changelog

## GruvBAUX Prototype (Pre-v0.1) - December 2025

### Major Changes
- **FreeBSD Migration**: Complete restructure from Debian to FreeBSD ports/src model
- **Directory Reorganization**: New layout with src/, ports/, patches/, scripts/, docs/, archive/
- **Package Renaming**: keymap → bbase, consistent b* naming (baux, bwm, bterm, bvi)
- **Unified Gruvbox Theming**: Gruvbox colors across console, dwm/bwm, neovim, tmux, and all components
- **Documentation Overhaul**: FreeBSD handbook-style structure with cross-references
- **NomadBSD Integration**: Adopted unionfs-fuse persistence, bootloader/UEFI handling, automatic hardware setup

### Code Development Milestones
#### Milestone 1: bbase Foundation ✅
- **Created FreeBSD port structure** for bbase package
- **Fixed keymap installation paths** for FreeBSD (/usr/share/syscons/keymaps/)
- **Added installation script** for manual testing on X300
- **Verified keymap file format** is correct FreeBSD kbd format
- **Status**: Ready for testing on X300 ThinkPad

#### Milestone 2: baux Session Manager ✅
- **Created FreeBSD port structure** for baux package
- **Fixed installation paths** from /usr/share/ to /usr/local/
- **Updated tmux configuration** for FreeBSD paths
- **Added dependencies** for tmux and neovim
- **Created installation script** for manual testing
- **Status**: Ready for testing on X300 ThinkPad

#### Milestone 3: bvi Editor Wrapper ✅
- **Created FreeBSD port structure** for bvi package
- **Fixed config file paths** in bvi.sh wrapper
- **Created missing config files** (/usr/local/etc/bvi/init.vim, vimrc.tiny)
- **Added Gruvbox theming** to neovim configs
- **Status**: Ready for testing on X300 ThinkPad

#### Milestone 4: Path Fixes & FreeBSD Compatibility ✅
- **Fixed shebang paths** from /bin/bash to /usr/local/bin/bash in all scripts
- **Replaced sudo with doas** in all installation scripts
- **Updated install-baux-manual.sh** with correct relative paths
- **Fixed file location issues** in port install scripts (baux.conf, bvi.sh)
- **Updated tmux theming** to proper Gruvbox colors
- **Created missing bvi config files** for neovim integration
- **Status**: All core components ready for X300 testing

#### Milestone 5: Documentation Updates ✅
- **Updated Installation.md** to reflect current manual installation process
- **Updated README.md** with correct quick start instructions
- **Verified Configuration.md** Gruvbox theming documentation
- **Status**: Documentation matches current implementation

#### Milestone 6: Unified Installation & Logging ✅
- **Created install-baux-unified.sh** with comprehensive logging
- **Added system information logging** (FreeBSD version, user, permissions)
- **Implemented dependency checking** (doas, packages, repository structure)
- **Added error handling and verbose output** for all installation steps
- **Created debug-baux.sh** for pre-installation diagnostics
- **Enhanced test-baux.sh** with detailed troubleshooting hints
- **Status**: Installation now creates detailed logs for remote debugging
- **Implemented intelligent fallback** (neovim → vim → vi)
- **Added lite configuration** with Gruvbox theming
- **Created installation script** for manual testing
- **Fixed configuration paths** for FreeBSD
- **Status**: Ready for testing on X300 ThinkPad
- **System Probe Tool**: `scripts/baux-probe.sh` for compatibility testing
- **X300 Focus**: Primary development on ThinkPad X300 hardware
- **LAN-First Mesh**: Local network session sharing before cloud deployment

#### Milestone 7: bwm Window Manager Implementation ✅
- **Created FreeBSD port structure** for bwm package (dwm fork)
- **Implemented BAUX session integration** with status bar display
- **Added Mod4+1-9 session switching** matching tmux behavior
- **Integrated Gruvbox theming** with toxic green color scheme
- **Created proper dwm patches** for BAUX functionality
- **Added TMUX integration** with Alt+b keybinding for baux-bot
- **Status**: Ready for testing on X300 ThinkPad with X11

#### Milestone 8: chaos Anti-Burn-In Screensaver ✅
- **Created FreeBSD port structure** for chaos package
- **Implemented idle detection** with 15-minute timeout
- **Added dynamic tmux effects** (pane splitting, swapping, rotation)
- **Created status bar chaos** with random messages and colors
- **Implemented instant recovery** on any keypress
- **Added dependencies** for btop, cmatrix, fastfetch
- **Status**: Ready for testing on X300 ThinkPad

#### Milestone 9: baux-bot AI Assistant Implementation ✅
- **Created FreeBSD port structure** for baux-bot package
- **Adapted existing AI framework** for FreeBSD workstation use
- **Implemented auto-detection** of RoxieOS repo location
- **Added TMUX integration** with Alt+b keybinding
- **Created setup automation** with baux-bot-setup script
- **Optimized model selection** for workstation performance
- **Added real-time repo monitoring** with RAG system
- **Status**: Ready for testing on X300 ThinkPad with Ollama

#### Milestone 10: Installation Script Privilege Escalation Bug ✅
- **Root Cause Identified**: bbase install.sh uses hardcoded `doas` commands
- **Issue**: When running as root, `run_privileged()` correctly skips doas, but bbase install.sh ignores this
- **Symptom**: "doas: Operation not permitted" during keymap installation
- **Impact**: Blocked bbase installation, preventing Caps→Esc functionality
- **Fix Implemented**: Updated bbase install.sh with intelligent privilege detection
- **Solution**: Script now detects root vs regular user and handles permissions accordingly
- **Fallback**: Uses local keymap directory if system directory unavailable
- **Status**: Bug resolved, installation now works for both root and regular users

### New Features
- **bbase**: System foundation with global Caps→Esc keymap
- **baux**: Immortal tmux sessions with resurrection
- **bwm**: dwm fork with BAUX session integration and status bar
- **bterm**: st fork with BAUX theming (placeholder)
- **bvi**: Enhanced neovim wrapper with Gruvbox theming
- **chaos**: Anti-burn-in screensaver with idle detection
- **baux-bot**: AI assistant with Ollama integration and repo monitoring
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