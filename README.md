# RoxieOS - BAUXBSD Development Environment

**Immortal sessions across devices. AI-powered development. Zero friction cloning.**

*Codename: BAUX-MESH - Distributed session resurrection via Tailscale + Headscale*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FreeBSD](https://img.shields.io/badge/FreeBSD-15.0+-red.svg)](https://www.freebsd.org/)
[![GitHub issues](https://img.shields.io/github/issues/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/issues)
[![GitHub stars](https://img.shields.io/github/stars/badlandz/RoxieOS)](https://github.com/badlandz/RoxieOS/stargazers)

## ⚠️ **CURRENT STATUS: PROTOTYPE WITH KNOWN ISSUES**

**This is a working prototype requiring manual workarounds.** See [BUG_REPORT.md](BUG_REPORT.md) for complete issue documentation and [BWM_BUILD_FIXES.md](ports/bwm/BWM_BUILD_FIXES.md) for build troubleshooting.

### **Quick Status**
- ✅ **Core Components**: baux, bvi, ollama, keymaps working
- ✅ **bwm Builds**: Window manager compiles successfully
- ❌ **Installer**: Missing core components, requires manual fixes
- ❌ **BAUX-MESH**: Not implemented (planned Phase 3)

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

## Key Features

### 🔄 **PARTIALLY WORKING: Distributed Mesh** (Phase 1 Partial)
- **Headscale + Tailscale**: 0% packet loss, sub-1ms latency confirmed
- **Direct Peer Connectivity**: .101 ↔ .133 mesh operational
- **Session Resurrection**: SSH-based cross-device session access
- **bwm Window Manager**: BAUX-themed dwm fork with Gruv-BAUX colors + Super+1-9 keymaps
- **Session Switcher**: Alt+1-9 switches to Session1-9 (auto-creates, rename as needed) ✅
- **Mesh Registry**: SQLite-based session tracking (planned)

### ✅ **WORKING: AI-Powered Development** (Multi-Backend)
- **baux-bot**: Immortal AI assistant with RAG, socket IPC, tool routing
- **xai-chat**: Direct Grok/Ollama integration with API key management
- **Smart Routing**: 16+ backends with intelligent model selection
- **Context Awareness**: File/code context sent with queries

### 🔄 **PARTIALLY WORKING: Immortal Sessions** (Cross-Device Persistence)
- **tmux Resurrection**: Sessions survive terminal kills/restarts
- **ZFS Snapshots**: FreeBSD-native persistence layer
- **SeaweedFS Buffering**: Distributed storage for session state
- **Hardware Independence**: Sessions work on any enrolled device

## 🚨 **KNOWN ISSUES & WORKAROUNDS**

### **Critical Installation Issues**
- **Missing bbase**: Console fonts/keymaps not installed automatically
- **Build Script Bugs**: Linux paths hardcoded in FreeBSD scripts

### **Workaround Installation**
```bash
# 1. Install base system + Xorg FIXED

# 2. Manual bbase install (MISSING FROM AUTOMATED INSTALL)
cd ~/src/RoxieOS/ports/bbase && doas ./install.sh

# 3. Fix bwm build script paths
# Edit build-bwm-simple.sh: sudo→doas, /usr/X11R6→/usr/local, #!/bin/sh→#!/usr/local/bin/bash
# FIXED

# 4. Install bwm
doas ./build-bwm-simple.sh

# 5. Manual accessibility setup because I'm blind and this is still a bug, not working
# WHY does anyone make the default font only readable with a magnifying glass??!!
doas sysrc allscreens_flags="-f cp437-8x16"
echo "Xft.dpi: 192" >> ~/.Xresources
```

See [BUG_REPORT.md](BUG_REPORT.md) for complete issue documentation.

## Installation

### **Automated Install** (Currently Broken)
```bash
git clone https://github.com/badlandz/RoxieOS.git
cd RoxieOS
./install.sh  # See BUG_REPORT.md for required manual fixes
```

### **Manual Component Installation**
```bash
# Install individual components
cd ports/baux && doas ./install.sh
cd ../baux-bot && doas ./install.sh
cd ../bwm && doas ./build-bwm-simple.sh  # After fixing paths
```

## Usage

### **Start BAUX Environment**
```bash
# Start tmux with BAUX configuration
baux

# Or use individual components
bvi  # Neovim with BAUX config
baux-bot what is baux  # AI assistant
```

### **Session Management**
```bash
# Switch sessions (when working)
baux 3  # Switch to session-3

# Cross-device access (when mesh implemented)
baux pull remote-host session-name
```

### **Window Management** (bwm)
```bash
# Start X session
startx  # Launches bwm window manager

# Keybindings (when working)
Super+1-9  # Switch workspaces
Alt+1-9    # Switch sessions
```

## Development Status

### **Phase 1: Core Infrastructure** ✅
- FreeBSD base system with accessibility
- Basic component installation
- AI integration working

### **Phase 2: Session Resurrection** 🔄
- tmux persistence working
- Cross-device SSH access working
- Mesh infrastructure planned

### **Phase 3: BAUX-MESH** ❌
- Headscale server setup
- Distributed session discovery
- Real-time session sync

## Contributing

### **Development Workflow**
1. **Code in ~/src/RoxieOS** on target systems
2. **Commit immediately** after changes
3. **Push to GitHub** for synchronization
4. **Test on all systems** before merging

### **Bug Reporting**
- See [BUG_REPORT.md](BUG_REPORT.md) for known issues
- Use GitHub issues for new problems
- Include system details (.101/.133) and reproduction steps

## Documentation

- **[BUG_REPORT.md](BUG_REPORT.md)**: Complete issue documentation and workarounds
- **[BWM_BUILD_FIXES.md](ports/bwm/BWM_BUILD_FIXES.md)**: bwm build troubleshooting
- **[docs/](docs/)**: Architecture and implementation details
- **[AI-BOT-WARNING.md](AI-BOT-WARNING.md)**: AI development guidelines

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Roadmap

### **Immediate (Pre-v0.1)**
- Fix Xorg input issues
- Complete automated installer
- Stabilize bwm window manager

### **v0.1 Release**
- Working BAUX-MESH
- Complete session resurrection
- Production-ready installer

### **Future**
- Live USB image
- Multi-platform support
- Advanced AI features

---

**Status**: Working prototype with extensive manual workarounds required. See [BUG_REPORT.md](BUG_REPORT.md) for complete issue tracking.</content>
<filePath>README.md
