# RoxieOS - GruvBAUX Prototype

**Clone your workstation from USB in 5 seconds. Immortal sessions, zero friction.**

*Codename: GruvBAUX - Unified Gruvbox theming across all layers*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FreeBSD](https://img.shields.io/badge/FreeBSD-15.0+-red.svg)](https://www.freebsd.org/)
[![GitHub issues](https://img.shields.io/github/issues/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/issues)
[![GitHub stars](https://img.shields.io/github/stars/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/stargazers)

## Overview

RoxieOS is a minimal FreeBSD-based operating system designed for instant workstation cloning and persistent development environments. Inspired by NomadBSD's live USB persistence approach, RoxieOS uses unionfs-fuse for read-only base systems with writable overlays. Boot from USB, clone your exact setup in seconds, and continue working seamlessly across any hardware.

**GruvBAUX Prototype**: This pre-v0.1 release features unified Gruvbox theming across console, dwm/bwm, neovim, tmux, and all BAUX components. Sessions become distributed network resources via Headscale mesh networking, accessible from any enrolled device.

![RoxieOS Screenshot](https://via.placeholder.com/800x400/000000/00FF00?text=RoxieOS+Screenshot+Coming+Soon)

## Key Features

- **Distributed Sessions**: Sessions as network resources via Headscale mesh
- **Workstation Cloning**: Backup and restore complete environments instantly
- **Immortal Sessions**: Sessions survive reboots, crashes, and hardware changes
- **Unified Keymaps**: Consistent controls across console, WM, editor, and terminal
- **Gruvbox Theming**: Cohesive visual experience across all components
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
- **Caps Lock → Escape** globally (bbase)
- **baux command** starts tmux session with custom config
- **bvi filename** opens files with neovim (or vim/vi fallback)
- **bwm** window manager with session display in status bar
- **chaos** anti-burn-in screensaver
- **baux-bot** AI assistant (Alt+b in tmux, or `baux-bot` command)
- **xai-chat** AI assistant via XAI API (works without Ollama)
- **Gruvbox theming** in all components

### Development Status
**✅ Core Components Installed:**
- `bbase` - Keymap system (Caps→Esc working)
- `baux` - Session management
- `bvi` - Neovim editor integration
- Git/SSH - Development workflow ready

**🔄 AI Assistance (In Development):**
- **xai-chat**: XAI API integration (script argument bug affecting usability)
- **baux-bot**: Ollama-based assistant (Vulkan compatibility issues)
- **Manual Development**: Full access to codebase for manual debugging

**🎯 Current Development Workflow:**
1. **Code on workstation**: Edit files in `~/src/RoxieOS/`
2. **Test manually**: Use installed BAUX components
3. **Debug with knowledge**: Reference documentation and logs
4. **Iterate**: Push/pull changes as needed

### Current Test Platforms
- **Primary:** ThinkPad X300 (FreeBSD 15.0) - Your test system
- **Secondary:** Proxmox VM (FreeBSD 15.x) for server testing
- **Future:** Raspberry Pi, generic laptops

### Troubleshooting
If components don't work:
1. Check `./scripts/test-baux.sh` output for specific failures
2. Verify FreeBSD version: `freebsd-version` (needs 15.x)
3. Check dependencies: `pkg info tmux neovim`
4. Review installation logs for errors

### Reporting Issues
When reporting bugs, include the probe report and specify your platform.

## Contributing

We welcome contributions! See [Development Guide](docs/Development.md) for:

- Building from source
- Package development
- Testing guidelines
- Code style

### Getting Help

- 📖 [Handbook](docs/Handbook.md) - Complete documentation
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