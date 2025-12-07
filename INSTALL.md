# BAUXBSD Installation Guide
**Clone your workstation in 5 seconds**

## Workstation Cloning Workflow

### Phase 1: Backup Current Workstation
```bash
# On your current machine: Backup sessions, projects, configs to USB
baux-backup /mnt/usb/workstation-backup

# This saves:
# - Tmux sessions (immortal state)
# - Neovim sessions (open files, undo history)
# - Projects in ~/src/
# - All BAUX configs
```

### Phase 2: Create Clone-Ready USB
```bash
# Download BAUXBSD ISO
fetch https://bauxbsd.org/releases/BAUXBSD-15.0-RELEASE.iso

# Write to USB (creates bootable live environment)
dd if=BAUXBSD-15.0-RELEASE.iso of=/dev/da0 bs=1M conv=sync
```

### Phase 3: Boot New Machine and Clone
```bash
# Boot new laptop with BAUXBSD USB
# System boots live in <5 seconds

# Install core packages (fast, <400MB)
pkg install bbase baux bwm bterm bvi bweb chaos

# Enable BAUX keymap globally
echo 'keymap="baux"' >> /etc/rc.conf

# Enable cloning services
echo 'baux_enable="YES"' >> /etc/rc.conf
echo 'bwm_enable="YES"' >> /etc/rc.conf

# Clone your workstation
baux-clone /mnt/usb/workstation-backup

# You're productive instantly:
# Sessions revive, projects sync, keymaps active
# 1:shell  2:edit  3:web  4:project1  5:project2  6:——  7:——  8:——  9:——  15:33
```

## Package Details

### bbase
**Purpose:** System foundation with BAUX keymap
**Size:** 50MB installed
**Files:**
- `/usr/share/syscons/keymaps/baux.kbd` - Console keymap
- `/usr/local/share/X11/xkb/symbols/baux` - X11 keymap
- `/etc/rc.conf` - System configuration

**Key Features:**
- Caps Lock → Escape globally
- Mod4 keybindings for session switching
- Root autologin configuration

### baux
**Purpose:** Shell and session management
**Size:** 80MB installed
**Dependencies:** tmux, seaweedfs, rsync, git

**Key Features:**
- Immortal tmux sessions with resurrection
- Anti-nesting detection
- SeaweedFS buffering for offline sync
- Cross-machine session synchronization

**Configuration:**
```bash
# Main configuration
/usr/local/etc/baux/baux.conf

# Session storage
~/.local/share/baux/sessions/
```

### bwm
**Purpose:** Minimal window manager
**Size:** 25MB installed
**Dependencies:** dwm, picom

**Key Features:**
- Shows BAUX session names in bar
- Mod4+1-9 session switching
- BAUXWM=1 environment variable
- Consistent with tmux session management

**Keybindings:**
- Mod4+hjkl - Tag navigation
- Mod4+Enter - New terminal
- Mod4+Shift+1-9 - Move windows
- Mod4+b - Toggle status bar

### bterm
**Purpose:** BAUX-themed terminal
**Size:** 5MB installed
**Dependencies:** st, libXft

**Key Features:**
- BAUX color scheme
- Custom font rendering
- Perfect integration with bwm

### bvi
**Purpose:** Editor with intelligent fallback
**Size:** 90MB installed
**Dependencies:** neovim

**Key Features:**
- Neovim with Lazy.nvim integration
- Fallback: vim → vi.tiny
- Session state persistence
- LSP for embedded development

**Usage:**
```bash
bvi file.c           # Opens with neovim
bvi --fallback file.c  # Forces vim if neovim unavailable
```

**Note:** Intentionally replaces the basic `editors/bvi` binary editor with enhanced Neovim integration.

### bweb
**Purpose:** Keyboard-native browser
**Size:** 40MB installed
**Dependencies:** qutebrowser

**Key Features:**
- BAUX keybindings (hjkl navigation)
- Minimal interface
- No mouse required
- Ad-blocking by default

### chaos
**Purpose:** Anti-burn-in screensaver
**Size:** 1MB installed
**Dependencies:** tmux

**Key Features:**
- Idle-triggered after 15 minutes
- Manual activation with Mod4+c
- Random pane effects
- Instant restore on keypress

## Workflow Examples

### Development Session
```bash
# Start development environment
baux                    # Opens BAUX with sessions
Mod4+1                  # Switch to shell session
Mod4+2                  # Switch to editor session
Mod4+3                  # Switch to browser session
Alt+1-4                  # Navigate within session
```

### Session Resurrection
```bash
# Save current state
baux save

# Boot on different machine
baux revive --all

# Exact state restored: same panes, same files, same commands
```

### Cross-Machine Sync
```bash
# Sync projects between machines
baux sync forge          # Sync to 'forge' machine
baux sync nas             # Sync to NAS storage
baux sync --all           # Sync all configured targets
```

## ZFS Setup for Session Persistence

### Automatic Snapshots
```bash
# Install zfs-periodic
pkg install zfs-periodic

# Configure in /etc/periodic.conf
hourly_zfs_snapshot_enable="YES"
hourly_zfs_snapshot_pools="zroot"
hourly_zfs_snapshot_keep=24

daily_zfs_snapshot_enable="YES"
daily_zfs_snapshot_pools="zroot"
daily_zfs_snapshot_keep=7
```

### Session Resurrection
```bash
# Create snapshot before session
zfs snapshot zroot/usr/home@baux-session-start

# Restore session from snapshot
zfs rollback zroot/usr/home@baux-session-start

# List available snapshots
zfs list -t snapshot
```

## Troubleshooting

### Keymap Issues
```bash
# Verify keymap installation
dumpkeys | grep -i escape     # Should show Caps→Esc mapping

# Test in X11
setxkbmap -print | grep baux  # Should load BAUX symbols

# Reset if needed
kbdcontrol -l /usr/share/syscons/keymaps/us.kbd
```

### Session Problems
```bash
# List all sessions
baux list

# Kill broken session
baux kill session-name

# Reset configuration
baux reset --hard
```

### Performance Issues
```bash
# Check resource usage
btop                      # System monitor
ps aux | grep baux         # BAUX processes

# Optimize startup
baux optimize              # Cleanup old sessions
```

## Advanced Configuration

### Custom Keybindings
```bash
# Edit baux keymap
vi /usr/local/share/X11/xkb/symbols/baux

# Edit tmux bindings
vi /usr/local/etc/baux/baux.conf

# Reload configuration
baux reload
```

### Session Templates
```bash
# Create development template
baux template dev --shell --editor --web

# Create electronics template
baux template hw --serial --monitor

# Use template
baux new dev
```

This guide gets you from zero to productive in minutes, with a complete BAUXBSD environment that works consistently across all your hardware.