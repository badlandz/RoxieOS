# BAUXBSD GruvBAUX Prototype
**badlandz - root is love, layers forever**

## Vision Summary

BAUX is a minimalist swiss army knife for makers: USB boot to connect to your Neovim IDE in the BAUX-MESH in 5 seconds from ANY system, getting you to your code with the best vi/tools available on any broken embedded/SBC/server hardware for fast recovery and development.

## Core Philosophy

BAUX (BAckup/restore Universal eXperience) is RoxieOS's core framework for session persistence and cross-device continuity.

RoxieOS is not a traditional OS distribution. It's a portable, session-persistent environment that runs on any hardware (USB, VM, container, bare metal). Your digital workspace resurrects instantly anywhere, with full tmux/neovim sessions intact.

### The Three Eternal Layers

BAUX (BAckup/restore Universal eXperience) is RoxieOS's core framework for session persistence and cross-device continuity.

| Layer | Name | Purpose | Size | Target Hardware |
|--------|------|-----------|-------|-----------------|
| 1 | bbase | System foundation + keymap | <50MB | Any machine |
| 2 | baux | Shell/session manager with immortal tmux panes | +80MB | Every machine you touch |
| 3 | bwm | Window manager (dwm fork) with session integration | +25MB | Development machines |

## Package Architecture

### Core Packages (v0.1 Essential)

1. **bbase** - System foundation
   - Custom baux.kbd keymap (Caps→Esc global)
   - System-wide configurations
   - rc.d service scripts
   - Root autologin setup

2. **baux** - Shell/session manager
   - tmux with immortal pane resurrection
   - Bash wrapper with anti-nesting
   - SeaweedFS integration buffers
   - Session persistence across reboots

3. **bwm** - Window manager
   - dwm fork with BAUX integration
   - Shows tmux session names in bar
   - Sets BAUXWM=1 environment variable
   - Consistent Mod4 keybindings

4. **bterm** - Terminal
   - st fork with BAUX theming
   - Custom font rendering
   - Perfect color consistency

5. **bvi** - Editor wrapper
   - Neovim with Lazy.nvim integration
   - Fallback: vim → vi.tiny
   - Session state persistence
   - LSP for embedded development

6. **bweb** - Browser
   - qutebrowser (keyboard-native) or surf (minimal)
   - Consistent BAUX keybindings
   - Minimal dependencies

7. **chaos** - Screensaver
   - Anti-burn-in protection
   - Idle-triggered + manual activation
   - tmux pane chaos effects

### Optional Packages (-dev tier)

- **bview** - Image viewer (sxiv-based)
- **bmedia** - Media player (mpv wrapper)
- **baux-bot** - AI assistant with Ollama/Grok/Gemini integration
- **bdrop** - Full SeaweedFS session persistence

## FreeBSD Implementation

### Base System
- **FreeBSD 15.0-RELEASE** with native ZFS
- **Package management:** Ports system
- **Init system:** rc.d services
- **Filesystem layout:** /usr/local hierarchy

### Live Persistence (Inspired by NomadBSD)
RoxieOS adopts NomadBSD's unionfs-fuse approach for live USB persistence:
- Read-only base system with writable overlay
- Automatic filesystem expansion on first boot
- Support for both UFS and ZFS variants

See [NomadBSD Handbook](https://nomadbsd.org/handbook/handbook.html) for detailed persistence implementation.

### Bootloader & UEFI (NomadBSD Integration)
- Dual BIOS/UEFI support with EFI framebuffer fixes
- Custom bootloader with graphics driver detection
- Boot menu options for troubleshooting (disable graphics detection, syscons, etc.)

### Automatic Hardware Setup (NomadBSD Approach)
- **Graphics:** Auto-detection for Intel, NVIDIA, AMD with fallback to VESA/SCFB
- **Sound:** Pre-configured audio drivers with mixer tools
- **Network:** Wireless setup with NetworkMgr
- **Input:** Touchpad and keyboard configuration

### Keymap Integration
```
# Console keymap
/usr/share/syscons/keymaps/baux.kbd

# X11 keymap
/usr/local/share/X11/xkb/symbols/baux

# System configuration
/etc/rc.conf:
keymap="baux"
```

### RoxieOS Install Types
RoxieOS requires at least 2 installs for full functionality:

1. **Primary Install (Tailscale Holder)**: Public IP system running Tailscale, holds keys/routes for session access.
2. **Secondary Installs (1-99)**: Any hardware - containers, VMs, USB drives, bare metal - connect via Tailscale to grab persistent sessions.

### BAUX-MESH: Persistent Pane Ecosystem
BAUX-MESH enables seamless session resurrection across devices:
- Immortal tmux panes persist across reboots/crashes.
- Session naming: Default $HOSTNAME-1 to $HOSTNAME-9 for tty mapping; custom names allowed.
- Grab any session from any RoxieOS install via Tailscale (or LAN discovery pre-Tailscale).
- AI resources (baux-bot) distributed across mesh for optimal performance.
- 5-second boot to full productivity anywhere.

```bash
baux 3              # Switch to hostname-3 session
baux switch ProjectX baux02  # Switch to ProjectX on baux02
baux pull baux01 MyProject   # Pull MyProject from baux01
baux revive --all   # Restore exact state on any machine
```

## The Unified Workflow

### Finger → Brain Mapping (identical everywhere)

| Command | Layer | Action | Works Everywhere |
|---------|--------|---------|-----------------|
| Mod4+1-9 | bwm/tmux | Jump session | X + Console |
| Alt+1-9 | tmux | Jump window | Universal |
| hjkl | vim/tmux/bwm | Navigation | Universal |
| Mod4+Enter | bwm/bterm | New terminal | Universal |
| Mod4+b | bwm/tmux | Toggle status | Universal |

### Single Source of Truth
- **bwm running:** bwm bar shows session names
- **Console only:** tmux status shows session names
- **Never both:** BAUXWM=1 controls visibility

### Unified Gruvbox Theming
**GruvBAUX Prototype**: All components use Gruvbox color scheme for consistency:
- **Console:** Gruvbox vt(4) theme
- **dwm/bwm:** Gruvbox window borders and bar
- **neovim:** Gruvbox plugin
- **tmux:** Gruvbox status line
- **Terminal:** Gruvbox color palette

### AI-Powered Development Environment
**BAUX Bot Integration**: Seamless AI assistance across all layers, leveraging BAUX-MESH for distributed intelligence:
- **Local AI**: Ollama models for privacy-focused development
- **Cloud AI**: xAI Grok and Google Gemini for advanced queries
- **Mesh AI**: Distributed RAG and model execution across RoxieOS installs via Tailscale
- **Context Awareness**: Real-time codebase understanding via shared RAG pools
- **Keybindings**: Alt+b (tmux) and <leader>b (neovim) for instant AI help
- **Multi-Modal**: Code generation, debugging, documentation search, session resurrection

## Installation Strategy

### Core Installation
```bash
pkg install bbase baux bwm bterm bvi bweb chaos
# Auto-configures:
# - baux.kbd keymap
# - rc.d services
# - tmux resurrection
# - dwm session integration
```

### Development Environment
```bash
pkg install bview bmedia bbot bdrop
# Optional -dev packages for extended functionality
```

## Design Principles

1. **Minimal footprint:** <400MB total core installation
2. **Instant boot:** <5 seconds to productive environment
3. **Muscle memory:** Same keybindings everywhere
4. **State persistence:** Sessions survive anything
5. **Zero friction:** No setup, no configuration dialogs

## Future Roadmap

### v0.2 - Extended Persistence
- Full bdrop implementation with SeaweedFS
- Cross-machine session synchronization
- PostgreSQL knowledge base integration

### v1.0 - Complete Vision
- AI-powered development environment with custom-trained baux-bot model
- Automatic project resurrection
- Full digital twin implementation
- **baux-bot v1.0**: Custom fine-tuned AI model for RoxieOS, trained on codebase and user interactions (requires cloud GPU resources for training)

---

Root forever.
Layers forever.
FreeBSD forever.

– badlandz, December 2025