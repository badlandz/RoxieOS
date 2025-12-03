# BAUXBSD Technical Roadmap
**FreeBSD 15.0 Implementation Guide**

## Migration Strategy: Debian → FreeBSD

### Phase 1: Foundation (Week 1-2)
**Goal:** Basic FreeBSD system with BAUX keymap and core packages

#### 1.1 System Setup
```bash
# FreeBSD 15.0-RELEASE installation
# Download: https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/15.0/
pkg update
pkg install neovim tmux dwm st qutebrowser maim fbgrab seaweedfs
```

#### 1.2 Keymap Integration
```bash
# Install baux.kbd to system locations
cp baux.kbd /usr/share/syscons/keymaps/baux.kbd
cp baux.kbd /usr/local/share/X11/xkb/symbols/baux

# Enable in system
echo 'keymap="baux"' >> /etc/rc.conf
echo 'setxkbmap -symbols baux' >> /usr/local/etc/X11/xinitrc
```

#### 1.3 Core Package Testing
- Test bbase (system configs)
- Test baux (tmux session management)
- Verify Caps→Esc works everywhere
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
| bbase | bash, tmux | 50MB |
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

## Rollout Plan

### v0.1 Release Criteria
1. All 7 core packages ported to FreeBSD
2. Keymap integration working system-wide
3. Session resurrection functional
4. ISO boots under 5 seconds
5. Documentation updated

### v0.2 Release Criteria
1. bdrop full implementation
2. Cross-machine synchronization
3. bbot AI integration
4. Performance optimizations

---

This roadmap prioritizes working system over comprehensive features, ensuring v0.1 is achievable and immediately useful.