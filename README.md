# RoxieOS - BAUXBSD Development Environment

**Immortal sessions across devices. AI-powered development. Zero friction cloning.**

*BAUX-MESH - a Distributed session resurrection via Tailscale + Headscale*
*BAUX-MESH - the "ecosystem" result of tmux/nvim/tailscale/bash unifications*

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

RoxieOS is a three-layer development platform: **Live RoxieOS** (USB rescue tool) → **BAUX** (immortal toolkit in baux-mesh) → **baux-dev** (AI workstation full bare metal install). Boot anywhere, connect to mesh, resurrect your exact sessions instantly, access AI assistance across mesh networks. Add user live image and it becomes persistent access point to baux-mesh that can run from usb, disk, container, vm, sbc, whatever... 

## Overview

RoxieOS is a FreeBSD-based operating system that merges **FreeBSD's networking excellence** with **Debian's accessibility mastery**. Create immortal development environments that persist across hardware, survive crashes, and sync via mesh networks. Linux was used, and remains used for developoment and testing, but suffers from bloat, contant "reinventing the (now incompatible) wheel," but large pool of usable code. FreeBSD, despite it's more limited collection of compatible software (opencode still an issue?!) remains the far superior platform to "unify" a small subset of ports (packages) to create something that can't be done with a "new software program." It's the result of alligning compatibility and conductivity between the key core existing systems that creates "baux-mesh," so "baux-mesh" is not a "program." BAUX-MESH is the "result" of a handfull of properly configured existing software componants.

## Why

It's personal... I live in a dusty town, and I have poor eyesight. Computers don't last, dust builds up, they overheat, they die. They are disposable. But, my "workflow" has evolved over the last 20+ years as "poweruser/hack" (not programmer) to include a very custom configuration of window manager, editor, and project management tools. When one system goes down, I have to "start fresh." Usually, that involves grabbing the latest Linux Mint or Debian iso, installing on a new computer, spending half a day trying to get the fonts big enough that I can even read the screen to login, another half a day fixing keymaps, paths, bashrc, tmux, neovim. Then if I'm lucky it's "kinda usable" and still find 1-2 hours a day for weeks going "oh, I have to add that feature I use once every couple weeks, it's missing." Countless hours, days, weeks, occasionally months of the year are devoted to "fixing/building my IDE," and at the end of the day, it's jsut a handfull of very basic things, neovim, tmux, bash, dwm, and a terminal emulator. That's all I need, but they need to all WORK TOGETHER completely, have unified keymap patterns, know how to route me between projects and pull in AI support, have reasonable search capability (fzf, ripgrep), and getting it all "working" takes forever.

This is why I belive Linux is a "childish" OS, constantly reinventing the incompatible wheel, and at least FreeBSD keeps things simple, and there is "hope" of making it small, clean, and fast enough to run on RISC-V SBC for getting back to work on some random microprocesser firmware if I can create a "complete" from first boot to IDE iso image for recovery, saving UNHEARD of amounts of time configuring in the future.

Like Omarchy, it's basically "just a bunch of scripts," but unlike Omarchy it's not seeking "a modern desktop," rather, it's seeking unification of the most simple basic tools, so well configured they can "fall back" from bloated neovim with AI plugins to run on plain old vi with as many of the same features as possible and the exact same keymaps, and be running on a tiny underpowered system, and you can still "get back to your code and fix it" rather than configuring your IDE. RoxieOS is the OS tweaks to create a BAUX-MESH using extensive configuration for maximum functionality and uniform keymaps/interfaces across a small handful of existing software (headscale, tmux, neovim, bash, dwm, st). That's it. It sounds simple, it is simple. However it doesn't exist "out of the box" until now, with the project to create a RoxieOS live image.

It's an "OS" that's smaller, faster, and persistant. To do that requires 2-3 systems, so there's always "fallback" point to connect, and location to pull your latest configuration/project/code instantly from anywhere. Testing setup right now is:
1. Workstation (bare metal, simple compact desktop computer)
2. Laptop ($50 old laptop to test "off my lan" conducivity for remote use)
3. Cloud VM ($5/month system with real IP and domain name assigned)

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
