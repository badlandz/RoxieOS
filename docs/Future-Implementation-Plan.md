# BAUXBSD Implementation Status
**Completed Upgrades and Future Plans**

## ✅ Completed: Neovim Config Upgrade

### Standalone Config
- **Location**: `neovim/` directory
- **Framework**: Full LazyVim with performance optimizations
- **Plugins**: Complete development ecosystem
- **Keymaps**: BAUXBSD unified system

### bvi Package Variants
- **Lite Mode**: Pi Zero compatible (15MB)
  - Plugins: persistence, mini.files, undotree, gruvbox
  - Location: `ports/bvi/lite/`
- **Dev Mode**: Full workstation (50MB)
  - Plugins: All from standalone + vimwiki, dadbod, lazygit
  - Location: `ports/bvi/dev/`

### Keymap Integration
- **System-wide**: Consistent across console, bwm, tmux, neovim
- **Neovim**: `<C-hjkl>` navigation, `<leader>1-9` buffers, tmux integration
- **BAUX Bot**: `<leader>b/l` for AI assistance

## Chaos Screensaver Implementation

### Current Status
- **Location**: `ports/chaos/` (placeholder)
- **Features**: Idle detection, manual Mod4+c, tmux effects
- **Integration**: Session preservation with baux

### Next Steps
1. Implement tmux pane manipulation scripts
2. Add idle detection logic
3. Test with bwm integration
4. Ensure instant restoration on keypress

## Session Resurrection (baux revive)

### Current Status
- **ZFS Integration**: Planned with zfs-periodic snapshots
- **SeaweedFS**: Buffering for hot storage
- **Neovim**: folke/persistence plugin integrated

### Implementation Plan
1. Extend baux with revive commands
2. Add SeaweedFS API integration
3. Implement ZFS snapshot automation
4. Test cross-machine resurrection

## DWM Patches for bwm

### Current Status
- **Source**: `patches/upstream/dwm/` (dwm source moved)
- **Patches**: `patches/roxanne.patch` (placeholder)

### Patches Needed
- **Session Display**: Show BAUX session names in bar
- **Keybindings**: Mod4+1-9 session switching
- **BAUXWM Integration**: Environment variable handling
- **Status Updates**: Real-time session info

### Build Process
```bash
# In ports/bwm/Makefile
do-build:
    cd ${WRKSRC} && patch < ${PATCHDIR}/roxanne.patch
    make
```

## ST Patches for bterm

### Current Status
- **Port**: `ports/bterm/` (placeholder created)
- **Source**: Need to add to `patches/upstream/st/`

### Patches Needed
- **BAUX Theming**: Color scheme matching bwm
- **Font Stack**: Optimized rendering
- **Integration**: Seamless with bwm/baux
- **Keymaps**: Consistent BAUX bindings

### Implementation
1. Obtain suckless/st source
2. Create BAUX patches
3. Build FreeBSD port
4. Integrate with bwm theming

## Config Files Organization

### System Configs
- **Keymap**: `ports/bbase/files/usr/share/syscons/keymaps/baux.kbd`
- **X11 Keymap**: `ports/bbase/files/usr/local/share/X11/xkb/symbols/baux`
- **rc.conf**: Auto-enable keymap and services

### User Configs
- **tmux**: `ports/baux/files/usr/local/etc/baux/tmux.conf`
- **neovim**: `neovim/` (standalone), `ports/bvi/lite/dev/` (variants)
- **bwm**: `ports/bwm/files/usr/local/etc/bwm/config.h`

## Build Scripts Enhancement

### Current Status
- **build-ports.sh**: Basic port building script
- **build-src.sh**: FreeBSD src patching
- **install-live.sh**: Upstream patching workflow
- **clone-workstation.sh**: Backup/restore automation

### Enhancements Needed
- Add bvi variant detection (lite/dev)
- Integrate neovim config selection
- Automate patch application
- Add dependency checking

## Testing Strategy

### Current Testing
- Keymap verification scripts
- Session resurrection testing
- Package installation validation

### Enhanced Testing
- Neovim config loading (lite/dev variants)
- Plugin compatibility on Pi Zero
- BAUX keymap consistency across layers
- Performance benchmarks (<5s boot, <200MB idle)
- Cross-architecture testing (amd64, aarch64)

## Integration Points

### ✅ Completed: bvi + baux
- folke/persistence for neovim session management
- Complements baux tmux resurrection
- Auto-restore buffers and cursor positions

### bwm + baux
- BAUXWM=1 environment variable
- Session name display in status bar
- Mod4+1-9 session switching

### bterm + bwm
- Matching BAUX color schemes
- Font rendering consistency
- Seamless terminal spawning

### chaos + baux
- Session state preservation during effects
- Instant restoration on any keypress
- Non-disruptive idle operation

This plan provides the roadmap for implementing all planned features while maintaining the clean FreeBSD ports structure.