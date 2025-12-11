# RoxieOS - BAUXBSD Workstation OS

**Immortal sessions across devices. AI-powered development. Zero friction cloning.**

*Codename: BAUX-MESH - Distributed session resurrection via Tailscale + Headscale*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FreeBSD](https://img.shields.io/badge/FreeBSD-15.0+-red.svg)](https://www.freebsd.org/)
[![GitHub issues](https://img.shields.io/github/issues/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/issues)
[![GitHub stars](https://img.shields.io/github/stars/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/stargazers)

## Vision Summary

BAUXBSD is a three-layer cyberdeck OS: **Live RoxieOS** (USB rescue tool) → **BAUX** (immortal toolkit) → **baux-dev** (AI workstation). Boot anywhere, resurrect your exact sessions instantly, access AI assistance across mesh networks.

## Overview

RoxieOS is a FreeBSD-based operating system that merges **FreeBSD's networking excellence** with **Debian's accessibility mastery**. Create immortal development environments that persist across hardware, survive crashes, and sync via mesh networks.

**Three Eternal Layers** (never compromise):
1. **RoxieOS (Live)**: <400MB USB rescue tool, boots in <12s on Pi Zero
2. **BAUX**: Immortal tmux+neovim toolkit, never asks for sudo again
3. **baux-dev**: AI workstation with SQL brain, knowledge graphs, OCR

**GruvBAUX Prototype**: Pre-v0.1 with unified Gruvbox theming, mesh session resurrection, and AI integration. Sessions become network resources accessible from any enrolled device.

**Accessibility First**: 9-font stack supports dyslexia/low-vision. 20pt terminals, high-contrast themes, keyboard navigation everywhere.

![RoxieOS Screenshot](https://via.placeholder.com/800x400/000000/00FF00?text=RoxieOS+Screenshot+Coming+Soon)

## Key Features

### ✅ **WORKING Distributed Mesh** (Phase 1 Complete)
- **Headscale + Tailscale**: 0% packet loss, sub-1ms latency confirmed
- **Direct Peer Connectivity**: .101 ↔ .133 mesh operational
- **Session Resurrection**: SSH-based cross-device session access
- **bwm Window Manager**: BAUX-themed dwm fork with Gruv-BAUX colors + Super+1-9 keymaps
- **Session Switcher**: Alt+1-9 switches tmux sessions by position ✅ (no conflicts!)
- **Mesh Registry**: SQLite-based session tracking (planned)

### ✅ **AI-Powered Development** (Multi-Backend)
- **baux-bot**: Immortal AI assistant with RAG, socket IPC, tool routing
- **xai-chat**: Direct Grok/Ollama integration with API key management
- **Smart Routing**: 16+ backends with intelligent model selection
- **Context Awareness**: File/code context sent with queries

### ✅ **Immortal Sessions** (Cross-Device Persistence)
- **tmux Resurrection**: Sessions survive terminal kills/restarts
- **ZFS Snapshots**: FreeBSD-native persistence layer
- **SeaweedFS Buffering**: Distributed storage for session state
- **Hardware Independence**: Sessions work on any enrolled device

### ✅ **Accessibility First Design**
- **9-Font Stack**: JetBrains Mono, Fira Code, OpenDyslexic, Atkinson Hyperlegible, etc.
- **20pt Terminals**: Maximum visibility for low-vision users
- **High Contrast**: Toxic green-black cyberdeck themes
- **Keyboard Navigation**: Unified keymaps across all layers

### ✅ **Unified Development Experience**
- **Gruvbox Theming**: Console → WM → Editor → Terminal consistency
- **Mod4=dwm, Alt=tmux, hjkl=vim**: Same keys everywhere
- **Fallback Chains**: nvim → vim → vi, AI → tools → none
- **Zero Friction**: Boot → `baux` → Your exact environment

### ✅ **FreeBSD Native + Debian Heritage**
- **Ports System**: 32 packages with FreeBSD rc.d services
- **ZFS Integration**: Snapshots, clones, send/receive for persistence
- **Live Systems**: Unionfs-fuse persistence (NomadBSD-inspired)
- **Debian Fallback**: Complete alternative implementation available

## Quick Start

### Prerequisites
- FreeBSD 15.0+ system (tested on ThinkPad X300)
- Basic FreeBSD knowledge

### Installation
```bash
# Clone the repository
git clone git@github.com:badlandz/RoxieOS.git
cd RoxieOS

# Install core BAUX system
./install.sh -f  # Force install all components

# Start BAUX session
baux
```

### What You Get
- **Caps Lock → Escape** globally (roxieos-base)
- **Root autologin** on console (roxieos-base)
- **baux command** starts tmux session with custom config
- **bvi filename** opens files with neovim
- **bwm** window manager with BAUX theming
- **baux-bot** AI assistant with 16+ backends
- **xai-chat** direct Grok/Ollama integration
- **9 accessibility fonts** with proper fallbacks
- **Gruvbox theming** across all components

### Current Status
- **32 FreeBSD ports** - Complete BAUXBSD ecosystem
- **Mesh networking** - Headscale + Tailscale operational
- **AI integration** - Multi-backend with intelligent routing
- **Accessibility** - 9 fonts with keyboard navigation
- **System foundation** - roxieos-base provides core configuration

### Testing & Development
- **Start BAUX**: `baux` (tmux session with AI integration)
- **AI Assistant**: `baux-bot` (16+ backends, socket daemon planned)
- **Editor**: `bvi filename` (neovim with BAUX configuration)
- **Mesh Test**: `ping 100.64.0.2` (test mesh connectivity)
- **Window Manager**: `bwm` (dwm fork with BAUX theming)

### Current Platforms
- **Primary:** ThinkPad X300 (FreeBSD 15.0) - Active development
- **Mesh Nodes:** .101 (baux01) + .133 (01x300) - Operational
- **Future:** Raspberry Pi, additional laptops

### Reporting Issues
When reporting bugs, include the probe report and specify your platform.

## Combined Innovation: FreeBSD + Debian Synergy

**FreeBSD Core (Networking & Persistence):**
- **Headscale Mesh**: Distributed session resurrection across devices
- **ZFS Integration**: Snapshots, clones, send/receive for session persistence
- **Ports System**: 39 packages with proper dependencies and rc.d services
- **AI Integration**: Multi-backend AI with intelligent routing

**Debian Heritage (Accessibility & Live Systems):**
- **21-Font Vision**: 9 implemented (43%) - JetBrains Mono, Fira Code, OpenDyslexic, Atkinson Hyperlegible, TeX Gyre, etc.
- **Live Systems**: Unionfs-fuse persistence, debootstrap builds
- **Package Infrastructure**: Local APT repositories, meta-packages
- **Accessibility First**: 20pt terminals, keyboard navigation, high contrast

**Salvaged Concepts (Ready for Implementation):**
- **Socket IPC**: Crash prevention for AI assistants
- **Tool Routing**: ripgrep/web search fallbacks before AI
- **BVI Integration**: Seamless editor AI workflows
- **Distributed Storage**: FUSE-based cross-device file sharing
- **Parallel Builds**: Dependency-aware compilation systems

## Contributing

We welcome contributions! See [Development Guide](docs/Development.md) for:

- Building from source
- Package development
- Testing guidelines
- Code style

### Integration Opportunities
- **Font Stack Migration**: Port Debian's accessibility fonts to FreeBSD ports
- **Live Build Enhancement**: Implement Debian's debootstrap approach in FreeBSD
- **Cross-Platform Session Sync**: Enable session resurrection across FreeBSD/Debian systems

### Getting Help

- 📖 [Handbook](docs/Handbook.md) - Complete documentation
- 🚀 [Mesh Quick Start](docs/Mesh-Quick-Start.md) - Get mesh working in 10 minutes
- 🐛 [Issues](https://github.com/badlandz/RoxieOS/issues) - Bug reports
- 💬 [Discussions](https://github.com/badlandz/RoxieOS/discussions) - Q&A

## License

MIT License - see [LICENSE](LICENSE) for details.

## Credits & Inspiration

**FreeBSD Ecosystem:**
- **NomadBSD**: Live USB persistence, unionfs-fuse, Qt installer
- **FreeBSD Handbook**: Documentation structure, rc.d services
- **Suckless Tools**: dwm, st, dmenu inspiration for bwm, bterm
- **Headscale**: Mesh networking for distributed sessions

**Debian Heritage:**
- **Live System Builds**: Debootstrap approach, accessibility fonts
- **Package Management**: APT repositories, meta-packages
- **Font Stack**: 21-font accessibility vision (9 implemented)
- **BVI Integration**: Editor AI workflows, socket IPC

**Salvaged Concepts:**
- **Socket Daemon Architecture**: Crash prevention for AI assistants
- **Tool Routing Systems**: ripgrep/web search before AI calls
- **20pt Terminal Launcher**: Accessibility-focused UI
- **Distributed Storage**: FUSE-based cross-device file sharing
- **Parallel Build Systems**: Dependency-aware compilation

**Alternative Implementations:**
- **coseismicbsd**: Complete alternative BAUXBSD approach
- **Roxanne Vision**: Original three-layer architecture
- **groksroxieos**: Merged implementation with interconnects

See [NomadBSD Handbook](https://nomadbsd.org/handbook/handbook.html) for live systems and [FreeBSD Porter's Handbook](https://docs.freebsd.org/en/books/porters-handbook/) for package development.

## Repository Status

- **Status**: Active Development (GruvBAUX Prototype Pre-v0.1)
- **Ports**: 32 total (26 existing + 6 new/enhanced)
- **Stability**: Core BAUX system production-ready
- **Mesh**: Headscale + Tailscale operational
- **AI**: Multi-backend with intelligent routing
- **Fonts**: 9 accessibility fonts implemented
- **License**: MIT
- **Issues**: [GitHub Issues](https://github.com/badlandz/RoxieOS/issues)
- **Discussions**: [GitHub Discussions](https://github.com/badlandz/RoxieOS/discussions)

**Root forever. Layers forever. FreeBSD + Debian forever.**

– badlandz, December 2025