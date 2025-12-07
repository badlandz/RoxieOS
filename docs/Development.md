# BAUXBSD Development Guide
**Planning, Roadmap, and Implementation**

## Project Planning

### Restructuring Plan
The project is transitioning from Debian-based packaging to FreeBSD src/ports model. See archive/docs/PLAN.md for the detailed restructuring plan, including:

- Migration from debian/ to FreeBSD ports/
- src/ tree patches for kernel/userland
- Live upstream patching workflow
- Workstation cloning integration

### NomadBSD Integration
RoxieOS incorporates key principles from NomadBSD for live USB systems:

- **Persistence:** unionfs-fuse for read-only base + writable overlay
- **Bootloader:** Dual BIOS/UEFI support with EFI fixes
- **Hardware Setup:** Automatic graphics/sound/network driver detection
- **Installer:** Qt-based GUI for hard disk installation
- **Setup:** First-boot wizard for localization and configuration

See [NomadBSD Handbook](https://nomadbsd.org/handbook/handbook.html) and [GitHub](https://github.com/nomadbsd/NomadBSD) for implementation details.

### Directory Structure
```
RoxieOS/
├── src/          # FreeBSD src tree patches
├── ports/        # FreeBSD ports for BAUX packages
├── patches/      # Live upstream patches
├── scripts/      # Build and install scripts
├── docs/         # Handbook-style documentation
└── archive/      # Legacy Debian packages and docs
```

## Technical Roadmap
**BAUXBSD Workstation Cloning Roadmap**

## Cloning-Centric Development Strategy

### Phase 1: Core Cloning Foundation (Week 1-2)
**Goal:** Bootable USB with instant workstation restoration

#### 1.1 System Setup for Cloning
```bash
# Create BAUXBSD ISO with cloning tools
# Download FreeBSD 15.0 + BAUX packages
pkg update
pkg install bbase baux bwm bterm bvi bweb chaos
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

### Phase 2: Package Migration (Week 3-4)
**Goal:** Convert all 7 core packages to FreeBSD ports

#### 2.1 Package Structure Conversion
```
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

#### 5.1 System Hardening
```bash
# Security configurations
echo 'sshd_enable="YES"' >> /etc/rc.conf
echo 'clear_tmp_enable="YES"' >> /etc/rc.conf
```

#### 5.2 ISO Creation
```bash
# Using FreeBSD release engineering tools
make release
# Custom /etc/rc.conf with baux keymap
# Pre-installed core packages
```

## Package Dependencies

### Core Package Matrix
| Package | FreeBSD Dependencies | Size |
|---------|-------------------|-------|
| bbase | bash, tmux | 50MB | *⚠️ install blocked*
| baux | tmux, seaweedfs, rsync, git | 80MB |
| bwm | dwm, picom | 25MB |
| bterm | st, libXft | 5MB |
| bvi | neovim | 90MB |
| bweb | qutebrowser | 40MB |
| chaos | tmux | 1MB |

### Optional Package Matrix
| Package | Dependencies | Size |
|---------|-------------|-------|
| bview | sxiv | 2MB |
| bmedia | mpv | 15MB |
| bbot | ollama | 4GB |
| bdrop | seaweedfs | 50MB |

## Testing Strategy

### Hardware Compatibility
- **amd64:** Modern laptops, desktops
- **aarch64:** Raspberry Pi 3/4/5, Pine64
- **Legacy:** 32-bit systems for rescue scenarios

### Performance Targets
- **Boot time:** <5 seconds to baux prompt
- **Memory usage:** <200MB idle (core packages)
- **Session restore:** <3 seconds from USB
- **Battery life:** Minimal impact on laptops

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
- [ ] Caps→Esc works in console
- [ ] Caps→Esc works in X11
- [ ] Mod4+1-9 switches sessions
- [ ] Alt+1-9 switches tmux windows
- [ ] hjkl navigation in vim/tmux/bwm
- [ ] bwm bar shows session names
- [ ] chaos screensaver activates
- [ ] bshot captures screenshots
- [ ] bweb launches with BAUX keybindings

## Development Workflow

### Testing Infrastructure
- **Primary Testbed:** ThinkPad X200 (FreeBSD 14.x)
- **Server Testing:** Proxmox VM (FreeBSD 15.x) on LAN
- **Probe Script:** `scripts/baux-probe.sh` for compatibility checking
- **Build Environment:** Debian development machine for package creation

### Local Development Setup
```bash
# On Debian development machine
git clone https://github.com/badlandz/RoxieOS.git
cd RoxieOS

# Build packages for testing
./scripts/build-ports.sh

# Copy to USB for ThinkPad testing
cp *.txz /mnt/usb/baux-packages/
```

## Rollout Plan

### Phase 1: Full -Dev Live USB (2-3 weeks)
**Goal:** Complete BAUX environment booting to X on ThinkPad X300**

#### Week 1: Core Packages ✅
- [x] bbase: Keymaps working everywhere (FreeBSD port + install script) - *⚠️ install script has privilege bug*
- [x] bvi: Neovim with full config (FreeBSD port + lite/dev variants)
- [x] baux: Local session management (FreeBSD port + tmux config)
- [ ] bwm: Window manager with session display
- [ ] chaos: Screensaver

#### Week 2: Live USB Integration
- [ ] Bootloader: EFI + BIOS support
- [ ] Persistence: unionfs-fuse implementation
- [ ] Package installation from USB
- [ ] X startup with session detection

#### Week 3: Full Environment
- [ ] bterm: Terminal with theming
- [ ] Build scripts: Working package creation
- [ ] Testing: Complete workflow on X200
- [ ] Documentation: Updated for working system

### Phase 2: Server-Only Derivation (1-2 weeks)
**Goal:** Extract BAUX server components for cloud/LAN deployment

#### Server Package Creation
- [ ] Identify server-only components (no X11, minimal GUI)
- [ ] Create baux-server package with Headscale integration
- [ ] Test on RackNerd VPS ($10.60/year 1GB plan recommended)
- [ ] LAN connectivity verification

#### Cloud Deployment Options
**RackNerd KVM VPS (Recommended for BAUX Server):**
- **1GB Plan:** $10.60/year (1 vCPU, 25GB SSD, 2000GB transfer) - Sufficient for basic BAUX server
- **2.5GB Plan:** $18.66/year (2 vCPU, 45GB SSD, 3000GB transfer) - Better for growth
- **FreeBSD Support:** Available via custom ISO
- **Locations:** Multiple US/EU datacenters

**Reference:** FreeBSD Server Setup Guide - https://www.youtube.com/watch?v=r-qn6DrJ6IA

#### Headscale Integration
- [ ] Domain setup (hs.coseismic.org)
- [ ] Server deployment scripts
- [ ] Security hardening for mesh authentication

### Phase 3: BAUX Mesh Enablement (1-2 weeks)
**Goal:** Add Headscale for distributed session management

#### Headscale Integration
- [ ] Headscale FreeBSD package
- [ ] Client/server configuration
- [ ] Authentication setup
- [ ] Mesh testing on LAN

#### Session Synchronization
- [ ] Cross-device session sync
- [ ] Remote session access
- [ ] Backup/restore over mesh

## Testing & Validation

### Manual Testing on X300
**Scripts ready for testing:**
- `scripts/install-baux-manual.sh` - Complete installation guide
- `scripts/test-baux.sh` - Component verification
- `scripts/baux-probe.sh` - System compatibility check

**Test Sequence:**
1. Run `baux-probe.sh` to verify system compatibility
2. Execute `install-baux-manual.sh` for core components
3. Use `test-baux.sh` to validate installations
4. Test individual components: `baux`, `bvi filename`, keymaps

### Expected Test Results
- **bbase**: Caps Lock acts as Escape globally
- **baux**: tmux session starts with custom config
- **bvi**: Opens files with neovim (or vim/vi fallback)

### Debug Information
**If tests fail:**
- Check FreeBSD version: `freebsd-version` (should be 15.x)
- Verify packages: `pkg info tmux neovim`
- Check paths: `ls /usr/local/bin/baux`
- View logs: Check system messages for errors

## Next Development Steps

### Immediate (This Week)
1. **Test on X300**: Run manual installation and verify components
2. **Fix Issues**: Address any path or dependency problems found
3. **Refine Scripts**: Improve installation scripts based on testing

### Short-term (Next Week)
1. **bwm Package**: Create FreeBSD port for dwm window manager
2. **chaos Package**: Implement tmux screensaver effects
3. **Integration Testing**: Test combined X11 + tmux + neovim workflow

### Medium-term (2-3 Weeks)
1. **Live USB**: Implement unionfs-fuse persistence
2. **Build System**: Create automated package building
3. **Headscale Prep**: Prepare for mesh networking

---

This plan prioritizes getting a working BAUX system on your ThinkPad first, then expanding to mesh capabilities. The probe script ensures compatibility, and the phased approach prevents the Headscale dependency from blocking initial development.