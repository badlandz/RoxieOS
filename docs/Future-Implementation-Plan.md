# BAUXBSD Future Implementation Plan
**Code Planning Without Editing**

## Chaos Screensaver Implementation

### Location
- **Code**: `ports/chaos/`
- **Patches**: `patches/chaos/`
- **Config**: `ports/chaos/files/usr/local/etc/chaos.conf`

### Features to Implement
- **Idle Detection**: Monitor user activity, trigger after 15 minutes
- **Manual Activation**: Mod4+c hotkey
- **Effects**: Random tmux pane manipulations, color cycling, status bar chaos
- **Integration**: Work with bwm and baux for seamless restoration

### Code Structure
```
ports/chaos/
├── Makefile              # FreeBSD port
├── pkg-descr            # Description
├── files/
│   └── usr/local/bin/chaos  # Main script
└── README.md            # Implementation notes
```

### Dependencies
- tmux for pane manipulation
- Integration with baux session management

## Session Resurrection (baux revive)

### Location
- **Code**: `ports/baux/src/`
- **Scripts**: `scripts/`
- **Buffers**: SeaweedFS integration in `ports/baux/files/`

### Features
- **ZFS Snapshots**: Cold storage with zfs-periodic
- **SeaweedFS Buffering**: Hot storage for network drops
- **Cross-Machine Sync**: rsync/git integration
- **Anti-Nesting**: SSH detection

### Implementation Plan
1. Extend baux script with revive command
2. Add SeaweedFS volume management
3. Integrate ZFS snapshot automation
4. Test resurrection across hardware

## DWM Patches for bwm

### Current Location
- **Source**: `patches/upstream/dwm/`
- **Patches**: `patches/roxanne.patch` (from PLAN.md)

### Patches Needed
- **Session Bar**: Display tmux session names when BAUXWM=1
- **Keybindings**: Mod4+1-9 for session switching
- **Integration**: Environment variable detection
- **Status Updates**: Real-time session name updates

### Build Process
```bash
# In ports/bwm/Makefile
do-build:
    cd ${WRKSRC} && patch < ${PATCHDIR}/roxanne.patch
    make
```

## ST Patches for bterm

### Location
- **Source**: `patches/upstream/st/` (create)
- **Patches**: `patches/bterm-baux.patch` (create)
- **Port**: `ports/bterm/`

### Patches Needed
- **Theming**: BAUX color scheme
- **Font Rendering**: Custom font stack
- **Integration**: Work with bwm and baux
- **Keybindings**: Consistent with BAUX system

### Implementation
1. Fork suckless/st
2. Apply BAUX patches
3. Create FreeBSD port
4. Test integration with bwm

## Config Files Organization

### System Configs
- **Keymap**: `ports/bbase/files/usr/share/syscons/keymaps/baux.kbd`
- **X11 Keymap**: `ports/bbase/files/usr/local/share/X11/xkb/symbols/baux`
- **rc.conf**: Auto-enable keymap and services

### User Configs
- **tmux**: `ports/baux/files/usr/local/etc/baux/tmux.conf`
- **neovim**: `ports/bvi/files/usr/local/etc/bvi/init.lua`
- **bwm**: `ports/bwm/files/usr/local/etc/bwm/config.h`

## Build Scripts Enhancement

### build-ports.sh
```bash
#!/bin/bash
# Build all BAUX ports
for port in bbase baux bwm bterm bvi bweb chaos; do
    cd ports/$port
    make install
done
```

### install-live.sh
```bash
#!/bin/bash
# Pull upstream, patch, install
# dwm, st, tmux, neovim sources
# Apply BAUX patches
# Install to system
```

## Testing Strategy

### Automated Tests
- Keymap verification
- Session resurrection
- Package dependencies
- Cross-architecture builds

### Manual Testing
- Workstation cloning workflow
- Session persistence across reboots
- Keybinding consistency
- Performance benchmarks

## Integration Points

### bwm + baux
- BAUXWM=1 environment variable
- Session name display in bar
- Consistent keybindings

### bterm + bwm
- Matching color schemes
- Font consistency
- Seamless terminal spawning

### chaos + baux
- Session state preservation during screensaver
- Instant restoration on keypress
- Non-disruptive operation

This plan provides the roadmap for implementing all planned features while maintaining the clean FreeBSD ports structure.