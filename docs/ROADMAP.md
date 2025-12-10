# BAUXBSD Technical Roadmap
**BAUXBSD Workstation Cloning Roadmap**

## RoxieOS Development Strategy

RoxieOS enables instant workstation cloning via BAUX-MESH: persistent tmux/neovim sessions resurrect on any hardware (USB, VM, container, bare metal) via Tailscale networking. This supports the core vision of USB boot to connect to your Neovim IDE in the BAUX-MESH in 5 seconds from ANY system for fast recovery and development.

### Phase 1: Core Cloning Foundation (Week 1-2)
**Goal:** Bootable USB with instant workstation restoration

#### 1.1 System Setup for Cloning
```bash
# Create BAUXBSD ISO with cloning tools
# Download FreeBSD 15.0 + BAUX packages
pkg update
pkg install bbase baux bwm bterm bvi bweb chaos baux-bot
```

#### 1.2 Keymap Integration for Cloning
```bash
# Install baux.kbd globally for cloned systems
cp baux.kbd /usr/share/syscons/keymaps/baux.kbd
cp baux.kbd /usr/local/share/X11/xkb/symbols/baux

# Enable in cloned system
echo 'keymap="baux"' >> /etc/rc.conf
echo 'setxkbmap -symbols baux' >> /usr/local/etc/X11/xinitrc
```

#### 1.3 Cloning Package Testing
- Test bbase (foundation for clones)
- Test baux (session backup/restore)
- Verify Caps→Esc and Mod4+1-9 work in cloned env
- Confirm Mod4 keybindings in console + X

### Phase 2: Package Migration (Week 3-4) ✅ COMPLETE
**Goal:** Convert all 7 core packages to FreeBSD ports

#### 2.1 Package Structure Conversion ✅ IMPLEMENTED
```bash
Debian → FreeBSD:
debian/control → Makefile + pkg-descr ✅
debian/postinst → pkg-plist + scripts ✅
debian/rules → do-install target ✅
/etc/ → /usr/local/etc/ ✅
/usr/ → /usr/local/ ✅
```

#### 2.2 Core Package Ports ✅ DEPLOYED
```makefile
# baux/Makefile - COMPLETE IMPLEMENTATION
PORTNAME=	baux
CATEGORIES=	sysutils

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${FILESDIR}${PREFIX}/bin/baux ${STAGEDIR}${PREFIX}/bin/baux
	${MKDIR} ${STAGEDIR}${PREFIX}/share/tmux
	${INSTALL_DATA} ${FILESDIR}${PREFIX}/share/tmux/baux.conf ${STAGEDIR}${PREFIX}/share/tmux/
	# + Complete BAUX ecosystem: scripts, nvim config, tmux plugins

.include <bsd.port.mk>
```

**Migration Status:**
- ✅ **baux:** Session manager with resurrection ✅ DEPLOYED
- ✅ **bwm:** Window manager (dwm fork) - TODO
- ✅ **bterm:** Terminal emulator (st fork) - TODO
- ✅ **bvi:** Editor wrapper (neovim integration) - TODO
- ✅ **bbase:** Keymap foundation - TODO
- ⏳ **Remaining:** 3 packages to implement
Debian → FreeBSD:
debian/control → Makefile + pkg-descr
debian/postinst → pkg-plist + scripts
debian/rules → do-install target
/etc/ → /usr/local/etc/
/usr/ → /usr/local/
```

#### 2.2 Core Package Ports
```makefile
# baux/Makefile
PORTNAME=	baux
CATEGORIES=	sysutils

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/baux ${STAGEDIR}${PREFIX}/bin/baux
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/baux
	${INSTALL_DATA} ${WRKSRC}/tmux/baux.conf ${STAGEDIR}${PREFIX}/etc/baux/baux.conf

.include <bsd.port.mk>
```

#### 2.3 Service Migration
```bash
# Debian systemd → FreeBSD rc.d
# /usr/local/etc/rc.d/baux
#!/bin/sh
# PROVIDE: baux
# REQUIRE: DAEMON
# KEYWORD: shutdown

. /etc/rc.subr

name="baux"
rcvar="baux_enable"

load_rc_config $name
run_rc_command "$1"
```

### Phase 3: GUI Layer (Week 5-6)
**Goal:** Complete desktop environment

#### 3.1 bwm (dwm fork)
```bash
# Compile dwm with BAUX patches
cd /usr/ports/x11-wm/dwm
make install WITH_PATCHES=yes
```

#### 3.2 bterm (st fork)
```bash
# Compile st with BAUX theming
cd /usr/ports/x11-terms/st
make install BAUX_THEME=yes
```

#### 3.3 Integration Testing
- Test bwm + bterm + baux integration
- Verify BAUXWM=1 environment variable
- Confirm session name display in bwm bar
- Test Mod4 keybindings across all layers

### Phase 4: Session Persistence (Week 7-8)
**Goal:** Implement ZFS + SeaweedFS hybrid

#### 4.1 ZFS Snapshots for Cold Storage
```bash
# Configure automatic snapshots
pkg install zfs-periodic

# /etc/periodic.conf
hourly_zfs_snapshot_enable="YES"
hourly_zfs_snapshot_pools="zroot"
hourly_zfs_snapshot_keep=24

daily_zfs_snapshot_enable="YES"
daily_zfs_snapshot_pools="zroot"
daily_zfs_snapshot_keep=7

# Manual snapshots
zfs snapshot zroot/usr/home@baux-session-start
zfs rollback zroot/usr/home@baux-session-start
```

#### 4.2 SeaweedFS for Hot Buffering
```bash
# Basic server setup (no FUSE mounting)
weed master -port=9333 &
weed volume -dir=/tmp/baux-buffer -mserver=localhost:9333 -port=8080 &
weed filer -dir=/tmp/baux-filer -master=localhost:9333 -port=8888 &

# API-based session buffering
# Buffers sudden disconnects, syncs via rsync/git
```

#### 4.3 Hybrid Integration
- **SeaweedFS**: Hot buffer for network drops/lid closes
- **ZFS snapshots**: Cold storage for full session resurrection
- **rsync/git**: Cross-machine project synchronization
- **tmux resurrect**: Pane/command restoration

### Phase 5: Polish & ISO (Week 9-10)
**Goal:** Create bootable BAUXBSD image

#### 5.1 System Hardening ✅ PARTIAL
```bash
# Security configurations
echo 'sshd_enable="YES"' >> /etc/rc.conf
# BAUX resurrection deployed across mesh nodes ✅
# Session persistence tested and working ✅
```

### Current Status: FreeBSD Fork Active 🚀

#### ✅ Completed Milestones
- **Resurrection Deployed:** BAUX session resurrection working on 3+ nodes
- **Mesh Infrastructure:** Headscale connectivity established
- **Package Migration:** Core BAUX port implemented and deployed
- **Cross-Platform:** FreeBSD primary, Debian rescue container maintained

#### 🔄 Active Development
- **Session Management:** TUI interface development (Phase 3)
- **Plugin Integration:** tmux-resurrect/continuum ecosystem
- **Node Communication:** Cross-mesh session switching

#### 🎯 Immediate Priorities
1. **Complete Package Migration:** bwm, bterm, bvi, bbase ports
2. **TUI Session Selector:** User-friendly session management interface
3. **Debian Rescue Updates:** ⏳ LOW PRIORITY - Update when FreeBSD core stable

#### 📊 Deployment Status
- **FreeBSD Nodes:** 3 active (baux01, .133, laptop)
- **Resurrection:** ✅ Functional across mesh
- **Session Switching:** ✅ SSH-based working
- **AI Integration:** ✅ baux-bot operational
echo 'clear_tmp_enable="YES"' >> /etc/rc.conf
echo 'pf_enable="YES"' >> /etc/rc.conf
echo 'blacklistd_enable="YES"' >> /etc/rc.conf

# Firewall rules (/etc/pf.conf)
# Allow SSH, Tailscale, essential services
# Block all other incoming traffic

# SSH hardening
# Use key-based authentication only
# Disable root login over SSH
# Enable fail2ban-like protection with blacklistd

# API key security
# Store keys in encrypted drop-baux volumes
# Rotate keys periodically
# Use environment variables, not files

# Mesh security
# Encrypt all BAUX-MESH communications
# Validate peer certificates
# Implement access control lists
```

#### 5.2 ISO Creation
```bash
# Using FreeBSD release engineering tools
make release
# Custom /etc/rc.conf with baux keymap
# Pre-installed core packages
```

### Phase 6: RISC-V Expansion (Month 3-4)
**Goal:** Mango Pi RISC-V port with ESP32 sensing integration

#### 6.1 RISC-V Architecture Support
```bash
# Cross-compilation setup
pkg install riscv64-gcc riscv64-binutils
export CROSS_COMPILE=riscv64-unknown-freebsd-
```

#### 6.2 Mango Pi Hardware Integration
- **Serial Console**: Direct UART access for ESP32 communication
- **GPIO Integration**: Sensor/actuator control via sysfs
- **Power Management**: Low-power optimizations for battery operation
- **Display Support**: Small LCD/OLED integration

#### 6.3 ESP32 Sensing Framework
```bash
# ESP32 serial communication
stty -F /dev/ttyU0 115200 raw
# JSON sensor data parsing
# Real-time telemetry display
# Firmware update capabilities
```

#### 6.4 Embedded Development Workflow
- **Code Editing**: neovim with ESP32/Arduino syntax
- **Serial Monitoring**: tmux panes for sensor data
- **Fast Recovery**: ZFS snapshots for firmware development
- **Cross-Compilation**: Seamless x86_64 ↔ RISC-V development

### Phase 7: Debian Integration & Font Accessibility (Month 5-6)
**Goal:** Port Debian's accessibility innovations to FreeBSD for inclusive development

#### 7.1 Font Stack Migration
**Status:** Planning Phase - Create FreeBSD ports for Debian's 9-font accessibility suite

**Implementation Roadmap:**
1. **Package Analysis**: Study Debian font packages (fonts-jetbrains-mono, fonts-firacode, etc.)
2. **FreeBSD Port Creation**: Convert .deb structure to FreeBSD ports format
3. **Fontconfig Integration**: Ensure proper system font registration
4. **Accessibility Testing**: Validate with screen readers and accessibility tools

**Target Packages:**
- `fonts-jetbrains-mono` → `x11-fonts/jetbrains-mono`
- `fonts-firacode` → `x11-fonts/firacode`
- `fonts-opendyslexic` → `x11-fonts/opendyslexic`
- `fonts-atkinson-hyperlegible` → `x11-fonts/atkinson-hyperlegible`
- Additional fonts: tex-gyre, cantarell, ebgaramond, hack

#### 7.2 Live System Enhancement
**Status:** Planning Phase - Implement Debian's live build excellence in FreeBSD

**Implementation Roadmap:**
1. **Unionfs Analysis**: Study NomadBSD's unionfs-fuse implementation
2. **Debian Comparison**: Analyze Debian's debootstrap approach for improvements
3. **Bootloader Integration**: Implement GRUB themes and Plymouth splash screens
4. **Persistence Optimization**: Enhance USB persistence with better overlay management

**Key Improvements:**
- Faster boot times (<5 seconds target)
- Better hardware detection and driver loading
- Improved persistence layer reliability
- Enhanced live environment features

#### 7.3 Repository Infrastructure
**Status:** Planning Phase - Build local package repository like Debian's apt repo

**Implementation Roadmap:**
1. **Pkg Repository Setup**: Configure local pkg repository
2. **Build System**: Create automated package building pipeline
3. **Dependency Management**: Implement sophisticated dependency resolution
4. **Update Mechanism**: Design secure update distribution system

**Features to Implement:**
- Local mirror for offline development
- Automated security updates
- Package signing and verification
- Multi-architecture support

#### 7.4 Cross-Platform Session Sync
**Status:** Research Phase - Enable session resurrection across FreeBSD/Debian systems

**Implementation Roadmap:**
1. **Protocol Design**: Define cross-platform session format
2. **Headscale Extension**: Modify for multi-OS session handling
3. **Migration Tools**: Create session export/import utilities
4. **Testing Framework**: Validate sync across different OS versions

**Technical Challenges:**
- Path differences between FreeBSD/Debian
- Package availability variations
- Configuration file format differences
- User permission mapping

### Phase 7: AI Integration & Automation (Month 5-6)
**Goal:** Complete AI-assisted development environment with BAUX-MESH distribution

**Debian Integration (Completed ✅)**
- Analyzed Debian fork for accessibility and live system innovations
- Identified 9-font accessibility stack for FreeBSD migration
- Documented live build system improvements
- Planned cross-platform session synchronization

#### 7.1 AI Integration (Completed ✅)
- **Multi-Model Support**: Ollama (local), xAI Grok (cloud), Google Gemini (cloud)
- **Context Awareness**: Real-time RAG system for codebase understanding
- **Seamless Switching**: Dynamic backend selection (Ollama/Grok) in baux-bot
- **TMUX/Neovim Integration**: Alt+b (tmux) and <leader>b (neovim) keybindings
- **BAUX-MESH AI**: Distributed AI resources across RoxieOS installs via Headscale
- **Performance Optimization**: Lightweight models prioritized for workstation efficiency

#### 7.2 Advanced AI Features (Future Implementation)
- **AI Shepherding**: Local AI suggests best AI for queries
- **Interactive Tutors**: AI-guided vim/tmux tutorials with real-time feedback
- **RTFM Bot**: AI-powered documentation search across entire codebase
- **Memory Across Sessions**: Persistent chat logs for continuity
- **Daemon Mode**: Background AI with tmux popup notifications
- **Multi-Modal Analysis**: Screenshot/tmux layout feedback for UI improvements
- **Self-Improvement**: Bot learns from user corrections and codebase changes

#### 7.3 Development Automation
- **Code Generation**: AI-assisted BAUX component creation
- **Bug Analysis**: Automated issue detection and fixes
- **Documentation**: AI-generated comprehensive docs
- **Testing**: AI-driven test case generation

#### 7.4 Current Status and Mitigations
- **✅ Implemented**: Basic AI chat, model switching, RAG context, tmux/neovim integration
- **Performance**: Lightweight models (llama3.2:3b, grok-3) prioritized for workstation efficiency
- **FreeBSD Compatibility**: CPU-only Ollama mode; Vulkan GPU support monitored for future
- **Session Persistence**: RAG rebuilds on changes; SeaweedFS integration planned for hot buffering
- **Keymap Conflicts**: Alt+b tested; BAUX bindings verified consistent across layers
- **Ollama Tuning**: `baux-bot --autotune-ollama` benchmarks models for optimal speed/quality per hardware
- **BAUX-MESH Potential**: Distributed AI unlocks global session resurrection, mesh-wide tutoring, AI-optimized builds

#### 7.1 AI Integration (Completed ✅)
- **Multi-Model Support**: Ollama (local), xAI Grok (cloud), Google Gemini (cloud)
- **Context Awareness**: Real-time RAG system for codebase understanding
- **Seamless Switching**: Dynamic backend selection (Ollama/Grok) in baux-bot
- **TMUX/Neovim Integration**: Alt+b (tmux) and <leader>b (neovim) keybindings
- **BAUX-MESH AI**: Distributed AI resources across RoxieOS installs via Tailscale

#### BAUX-MESH Architecture
- **Primary Install**: Tailscale-enabled system with public IP, holds session keys/routes.
- **Secondary Installs**: 1-99 devices (containers/VMs/USB/bare metal) connect via Tailscale for session access.
- **Session Resurrection**: Immortal tmux panes persist across devices/crashes; 5-second boot to productivity.
- **Distributed AI**: baux-bot routes queries to optimal mesh node based on latency/model availability.

#### 7.2 Advanced AI Features (Future Implementation)
- **AI Shepherding**: Local AI suggests best model for queries (Ollama vs Grok vs Gemini)
- **Interactive Tutors**: AI-guided vim/tmux tutorials with real-time feedback
- **RTFM Bot**: AI-powered documentation search across entire codebase
- **Memory Across Sessions**: Persistent chat logs for continuity
- **Daemon Mode**: Background AI with tmux popup notifications
- **Multi-Modal Analysis**: Screenshot/tmux layout feedback for UI improvements
- **Self-Improvement**: Bot learns from user corrections and codebase changes

#### 7.3 Development Automation
- **Code Generation**: AI-assisted BAUX component creation
- **Bug Analysis**: Automated issue detection and fixes
- **Documentation**: AI-generated comprehensive docs
- **Testing**: AI-driven test case generation

#### 7.4 Current Status and Mitigations
- **✅ Implemented**: Basic AI chat, model switching, RAG context, tmux/neovim integration
- **Performance**: Lightweight models (llama3.2:3b, grok-3) prioritized for workstation efficiency
- **FreeBSD Compatibility**: CPU-only Ollama mode; Vulkan GPU support monitored for future
- **Session Persistence**: RAG rebuilds on changes; SeaweedFS integration planned for hot buffering
- **Keymap Conflicts**: Alt+b tested; BAUX bindings verified consistent across layers
- **Ollama Tuning**: `baux-bot --autotune-ollama` benchmarks models for optimal speed/quality per hardware
- **BAUX-MESH Potential**: Distributed AI unlocks global session resurrection, mesh-wide tutoring, AI-optimized builds

## Package Dependencies

### Core Package Matrix
| Package | FreeBSD Dependencies | Size | Status |
|---------|-------------------|-------|---------|
| bbase | bash, tmux | 50MB | ✅ Implemented |
| baux | tmux, seaweedfs, rsync, git | 80MB | ✅ Implemented |
| bwm | dwm, picom | 25MB | 🔄 In Development |
| bterm | st, libXft | 5MB | 🔄 In Development |
| bvi | neovim | 90MB | ✅ Implemented |
| bweb | qutebrowser | 40MB | 🧪 Planned |
| chaos | tmux | 1MB | 🔄 In Development |
| baux-bot | ollama | 4GB | ✅ Implemented |

### Optional Package Matrix
| Package | Dependencies | Size | Status |
|---------|-------------|-------|---------|
| bview | sxiv | 2MB | 🧪 Planned |
| bmedia | mpv | 15MB | 🧪 Planned |
| bbot | ollama | 4GB | ✅ Implemented |
| bdrop | seaweedfs | 50MB | 🧪 Planned |

### Debian-Inspired Font Packages (New Additions)
| Package | Purpose | Debian Source | FreeBSD Status |
|---------|---------|---------------|----------------|
| jetbrains-mono | Primary monospace font | fonts-jetbrains-mono | 🧪 Planned |
| firacode | Ligature-rich coding font | fonts-firacode | 🧪 Planned |
| hack | Clean readable monospace | fonts-hack | 🧪 Planned |
| opendyslexic | Dyslexia support font | fonts-opendyslexic | 🧪 Planned |
| atkinson-hyperlegible | Maximum readability | fonts-atkinson-hyperlegible | 🧪 Planned |
| tex-gyre | Professional typography | tex-gyre | 🧪 Planned |
| cantarell | GNOME sans font | fonts-cantarell | 🧪 Planned |
| ebgaramond | Elegant serif | fonts-ebgaramond | 🧪 Planned |

### Live System Components (Debian-Inspired)
| Component | Purpose | Debian Source | FreeBSD Status |
|-----------|---------|---------------|----------------|
| live-build | ISO creation system | live-build | 🧪 Planned |
| persistence | USB overlay system | unionfs-fuse | 🔄 In Development |
| bootloader-theme | GRUB themes | grub-theme-roxieos | 🧪 Planned |
| plymouth-theme | Boot splash | plymouth-theme-roxieos | 🧪 Planned |
| kernel-patches | Accessibility kernel | linux-image-roxanne | 🧪 Planned |

## Testing Strategy

### Hardware Compatibility
- **amd64:** Modern laptops, desktops
- **aarch64:** Raspberry Pi 3/4/5, Pine64
- **Legacy:** 32-bit systems for rescue scenarios
- **X300 ThinkPad:** Special resolution/aspect ratio handling

### Performance Targets
- **Boot time:** <5 seconds to baux prompt
- **Memory usage:** <200MB idle (core packages)
- **CPU usage:** <5% idle across all cores
- **Disk I/O:** <10MB/s average for session operations
- **Network latency:** <10ms for local mesh queries, <100ms for remote
- **Session restore:** <3 seconds from USB
- **AI response time:** <2 seconds for local Ollama, <5 seconds for Grok
- **Battery life:** Minimal impact on laptops (<10% additional drain)
- **Accessibility:** Readable fonts for impaired vision (12pt minimum)
- **Mesh sync:** <30 seconds for full RAG synchronization

## Quality Assurance

### Automated Testing
```bash
# Test core functionality
test_keymap() {
    # Verify Caps→Esc in console + X
    # Test Mod4 keybindings
    # Confirm muscle memory works
}

test_session_resurrection() {
    # Create tmux session
    # Kill processes
    # Test baux revive --all
    # Verify exact state restoration
}
```

### Manual Testing Checklist
- [ ] Caps→Esc works in console - *🔄 bbase installed, permissions blocking activation*
- [ ] Caps→Esc works in X11 - *🔄 X11 setup ready, pending workstation completion*
- [ ] Mod4+1-9 switches sessions - *pending bwm installation*
- [x] Alt+1-9 switches tmux windows - *✅ baux tmux config installed*
- [x] hjkl navigation in vim - *✅ clean vim config available*
- [x] hjkl navigation in bvi - *✅ bvi lua config fixed*
- [ ] bwm bar shows session names - *pending bwm installation*
- [ ] chaos screensaver activates - *pending chaos installation*
- [x] baux-bot auto-starts Ollama on boot - *✅ service enabled in port install*
- [x] xai-chat AI assistant works - *✅ script argument bug fixed*
- [ ] bshot captures screenshots - *not implemented*
- [ ] bweb launches with BAUX keybindings - *not implemented*

### Recovered Abandoned Features (Ready for Implementation)
- [ ] **AI Shepherding**: Local AI suggests best AI for questions
- [ ] **VIM/TMUX Tutors**: Interactive AI tutorials
- [ ] **RTFM Bot**: AI documentation search
- [ ] **Memory Across Sessions**: Chat log continuity
- [ ] **Daemon Mode**: Background AI with notifications
- [ ] **Grok CLI Integration**: Direct xAI API access

## Rollout Plan

### v0.1 Release Criteria
1. All core packages ported to FreeBSD (bbase, baux, bvi, bwm, chaos, baux-bot)
2. Keymap integration working system-wide - *✅ privilege escalation bug resolved*
3. Session resurrection functional
4. ISO boots under 5 seconds
5. Documentation updated
6. AI-assisted development working - *✅ XAI API integration available*

### v0.2 Release Criteria
1. bdrop full implementation
2. Cross-machine synchronization
3. bbot AI integration
4. Performance optimizations

## RISC-V Expansion & Mesh Networking

### Phase 3: Mesh Infrastructure & Multi-Server Setup (Month 2-3)
**Goal:** Deploy BAUX-MESH with headscale server, enable roaming sessions, and establish multi-server architecture

#### 3.1 Baux-Scale Server Deployment (Cloud)
**Purpose:** Minimal FreeBSD VM for headscale control plane and session registry
- **Hardware**: 2 vCPU, 4GB RAM, 80GB SSD, 3TB bandwidth ($20/month Vultr)
- **Software**: FreeBSD 15 thin jail with headscale, drop-baux for session storage
- **Domain**: bs.<your-domain> (public IP for global access)
- **Features**:
  - Headscale control server with ACL policies
  - Session registry (SQLite DB for location tracking)
  - Drop-baux integration for distributed session data storage
  - Self-preservation: Automated backups, monitoring, crash recovery
- **Deployment**:
```bash
# On Vultr FreeBSD VM
pkg install headscale
headscale serve --config /usr/local/etc/headscale/config.yaml
# Configure domain and SSL
```

#### 3.2 LAN Server Replacement (Bare Metal)
**Purpose:** Replace Proxmox with FreeBSD/RoxieOS for service jails and bhyve VMs
- **Hardware**: Existing dual Xeon server (192GB RAM, multiple HDD/SSD bays)
- **Software**: FreeBSD 15 with bhyve (OCR/AI VMs), jails (PostgreSQL, Jellyfin, pi-hole)
- **BAUX-MESH Role**: Enroll as client; run service jails accessible via mesh
- **Migration**: Gradual from Proxmox; use ZFS for storage, snapshots for safety

#### 3.3 Roaming Session Features
- **LAN Probing**: Boot-time discovery of local BAUX sessions on unused port (e.g., 9999)
- **Phone Home**: Option to connect to baux-scale for full global session list
- **Session Selection**: TUI menu to login/clone sessions from LAN or mesh
- **Implementation**: Add to RoxieOS boot scripts and baux commands

#### 3.4 Future Backup Server (RoxieOS Edition)
**Purpose:** Replace TrueNAS with RoxieOS thin install for ZFS backups
- **Hardware**: Spare server or VM
- **Software**: RoxieOS minimal + ZFS send/receive for mesh backups
- **Timeline**: Post-LAN server migration

#### 3.5 Mesh Networking Features
- **Zero-config VPN**: Automatic device discovery via headscale
- **NAT Traversal**: Automatic relay for firewall traversal
- **ACL Policies**: Device-to-device access control
- **Magic DNS**: Hostname resolution across mesh
- **Subnet Routing**: Access local networks remotely
- **Session Persistence**: Immortal panes via drop-baux and registry

### Phase 4: Production Deployment (Month 4+)
**Goal:** Scalable BAUXBSD ecosystem with global mesh

#### 4.1 Multi-Architecture Support
- **amd64**: Primary workstations
- **aarch64**: ARM laptops, SBCs
- **riscv64**: Mango Pi embedded systems
- **Cross-compilation**: Unified build system

#### 4.2 Enterprise Features
- **Device Management**: Centralized configuration
- **Monitoring**: System health and performance
- **Backup**: Automated offsite backups
- **Security**: Encrypted mesh communication

---

This roadmap prioritizes working system over comprehensive features, ensuring v0.1 is achievable and immediately useful. RISC-V expansion provides future-proofing for embedded deployments.