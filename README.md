# RoxieOS - BAUXBSD Workstation OS

**Immortal sessions across devices. AI-powered development. Zero friction cloning.**

*Codename: BAUX-MESH - Distributed session resurrection via Tailscale*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FreeBSD](https://img.shields.io/badge/FreeBSD-15.0+-red.svg)](https://www.freebsd.org/)
[![GitHub issues](https://img.shields.io/github/issues/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/issues)
[![GitHub stars](https://img.shields.io/github/stars/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/stargazers)

## Vision Summary

BAUX is a minimalist swiss army knife for makers: USB boot to connect to your Neovim IDE in the BAUX-MESH in 5 seconds from ANY system, getting you to your code with the best vi/tools available on any broken embedded/SBC/server hardware for fast recovery and development.

## Overview

RoxieOS is a FreeBSD-based operating system for persistent, distributed development environments. Boot from USB, resurrect your exact tmux/neovim sessions on any hardware, and access AI assistance across a BAUX-MESH network. Sessions persist across reboots, crashes, and device switches via Headscale integration.

**Combined Innovation**: RoxieOS merges FreeBSD's networking excellence with Debian's accessibility and live system mastery, creating the most productive development environment available.

**GruvBAUX Prototype**: This pre-v0.1 release features unified Gruvbox theming across console, dwm/bwm, neovim, tmux, and all BAUX components. Sessions become distributed network resources via Headscale mesh networking, accessible from any enrolled device.

**Accessibility First**: Comprehensive font stack supports visual impairments and dyslexia. Live system builds enable instant productivity on any hardware.

![RoxieOS Screenshot](https://via.placeholder.com/800x400/000000/00FF00?text=RoxieOS+Screenshot+Coming+Soon)

## Key Features

- **WORKING Distributed Mesh**: Headscale + Tailscale mesh with direct peer connectivity (0% packet loss confirmed)
- **Immortal Baux-Bot**: AI assistant in persistent tmux session with loaded RAG, communicating via xai-Grok
- **Distributed Sessions**: Sessions as network resources via Headscale mesh (currently SSH-based, mesh Phase 3 planned)
- **Workstation Cloning**: Backup and restore complete environments instantly
- **Immortal Sessions**: Sessions survive reboots, crashes, and hardware changes
- **Unified Keymaps**: Consistent controls across console, WM, editor, and terminal
- **Gruvbox Theming**: Cohesive visual experience across all components
- **Revolutionary Font Stack**: 9 professional fonts for maximum accessibility (Debian integration)
- **Live System Builds**: Unionfs-fuse based live USB with persistence (NomadBSD-inspired)
- **AI-Powered Development**: Integrated xai-chat and baux-bot with Grok/Ollama backends
- **FreeBSD Native**: Ports system, ZFS snapshots, rc.d services
- **Minimal Footprint**: Core packages <400MB, boot in <5 seconds

## Quick Start

### Prerequisites
- FreeBSD 15.0+ system (tested on ThinkPad X300)
- Basic FreeBSD knowledge

### Manual Installation (Current Method)
```bash
# Install FreeBSD 15.0 and basic dependencies
pkg update
pkg install bash git neovim tmux xterm rsync curl

# Setup SSH keys for GitHub access
ssh-keygen -t ed25519 -C 'your-email@example.com'
# Add the public key (~/.ssh/id_ed25519.pub) to GitHub

# Configure git
git config --global user.name "your-username"
git config --global user.email "your-email@example.com"

# Clone and install BAUX
git clone git@github.com:badlandz/RoxieOS.git
cd RoxieOS

# Configure doas and install
echo "permit nopass :wheel" >> /etc/doas.conf
./scripts/install-baux-manual.sh

# Setup AI assistant for development
echo 'export GROK_API_KEY="your-xai-api-key"' >> ~/.bashrc
source ~/.bashrc
# xai-chat is now available for AI assistance

# Start BAUX session
baux
```

### What You Get
- **Caps Lock → Escape** globally (bbase) ✅
- **baux command** starts tmux session with custom config ✅
- **bvi filename** opens files with neovim (✅ lua config fixed)
- **bwm** window manager with session display in status bar
- **chaos** anti-burn-in screensaver
- **baux-bot** AI assistant (Alt+b in tmux, or `baux-bot` command)
- **xai-chat** AI assistant via XAI API (✅ argument passing fixed)
- **Gruvbox theming** in all components

### Development Status - WORKING MESH ACHIEVED! 🎉
**✅ Core Components (Repo):**
- `bbase` - Keymap system with Caps→Esc functionality
- `baux` - Session management with tmux integration
- `bvi` - Neovim editor integration (✅ lua config fixed)
- **Git/SSH** - Development workflow ready
- **TPM + Plugins** - Tmux resurrect and continuum installed

**✅ WORKING Mesh Nodes:**
- **baux01 (192.168.33.101)**: Online, mesh IP 100.64.0.1, direct peer connection
- **01x300 (192.168.33.133)**: Online, mesh IP 100.64.0.2, direct peer connection
- **Cloud Server (bs.coseismic.org)**: Headscale running, nodes approved
- **Connectivity**: 0% packet loss, sub-1ms latency confirmed

**✅ AI Assistance - FULLY OPERATIONAL:**
- **xai-chat**: XAI API integrated and working
- **baux-bot**: Immortal in persistent tmux session with loaded RAG
- **Grok Integration**: Direct communication via xai pipe confirmed
- **RAG System**: Active repo monitoring, knowledge base rebuilding
- **Backends**: Grok (primary), Ollama (local), multi-model switching

**✅ Mesh Recovery Lessons Learned:**
- **Headscale Setup**: Cloud VPS with domain, user creation, key generation
- **Client Enrollment**: `doas tailscale up --login-server=https://server --auth-key=KEY`
- **Node Approval**: `headscale nodes approve NODENAME` (not --identifier)
- **Permissions**: Add users to headscale group for CLI access
- **Troubleshooting**: Check tailscale status, headscale nodes list, ping mesh IPs

**🧪 Comparison Testing Ready:**
- **Clean vim** (`vim ~/.vimrc`) - Baseline vim configuration
- **Clean tmux** (`tmux -f ~/.tmux.conf`) - Baseline tmux configuration
- **BAUX vim** (`bvi file`) - BAUX neovim integration
- **BAUX tmux** (`baux`) - BAUX tmux session
- **Mesh ping** (`ping 100.64.0.2`) - Test mesh connectivity

**🎯 Current Development Workflow:**
1. **Code on workstation**: Edit files in `~/src/RoxieOS/`
2. **Test manually**: Compare clean vs BAUX implementations
3. **Debug with knowledge**: Reference documentation and logs
4. **Iterate**: Push/pull changes as needed
5. **Mesh Testing**: Use SSH between nodes, verify connectivity

### Current Test Platforms
- **Primary:** ThinkPad X300 (FreeBSD 15.0) - Your test system
- **Secondary:** Proxmox VM (FreeBSD 15.x) for server testing
- **Mesh Nodes:** .101 (baux01) and .133 (01x300) - WORKING
- **Future:** Raspberry Pi, generic laptops

### Troubleshooting
If components don't work:
1. Check `./scripts/test-baux.sh` output for specific failures
2. Verify FreeBSD version: `freebsd-version` (needs 15.x)
3. Check dependencies: `pkg info tmux neovim`
4. Review installation logs for errors

### Reporting Issues
When reporting bugs, include the probe report and specify your platform.

## Combined Innovation from Debian & FreeBSD

**Debian Heritage (Accessibility & Live Systems):**
- Revolutionary 9-font accessibility stack (JetBrains Mono, FiraCode, OpenDyslexic, Atkinson Hyperlegible, etc.)
- Production-ready live system builds with unionfs-fuse persistence
- Complete local package repository infrastructure
- Custom kernel builds with accessibility patches

**FreeBSD Innovation (Networking & AI):**
- Headscale mesh networking for distributed sessions
- AI-powered development (xai-chat, baux-bot with Ollama/Grok integration)
- Advanced session persistence with ZFS snapshots and SeaweedFS buffering
- Production-ready ports system and rc.d services

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

- **NomadBSD**: Live USB persistence, bootloader/UEFI handling, automatic hardware setup, Qt installer
- **FreeBSD Handbook**: Documentation structure and best practices
- **Suckless Tools**: dwm, st, dmenu inspiration for bwm, bterm
- **FreeBSD Server Setup**: https://www.youtube.com/watch?v=r-qn6DrJ6IA (cloud deployment reference)

See [NomadBSD Handbook](https://nomadbsd.org/handbook/handbook.html) for detailed implementation of live systems.

## Repository Status

- **Status**: Active Development
- **Version**: GruvBAUX Prototype (Pre-v0.1)
- **License**: MIT
- **Issues**: [GitHub Issues](https://github.com/badlandz/RoxieOS/issues)
- **Discussions**: [GitHub Discussions](https://github.com/badlandz/RoxieOS/discussions)

---

**Root forever. Layers forever. FreeBSD forever.**

– badlandz, December 2025