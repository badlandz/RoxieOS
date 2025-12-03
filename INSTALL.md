# BAUXBSD Installation Guide
**From USB to productive in 5 seconds**

## Quick Start

### 1. Create Bootable USB
```bash
# Download FreeBSD 15.0-RELEASE
fetch https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/15.0/FreeBSD-15.0-RELEASE-amd64-disc1.iso

# Write to USB
dd if=FreeBSD-15.0-RELEASE-amd64-disc1.iso of=/dev/da0 bs=1M conv=sync
```

### 2. Boot and Install Core
```bash
# On first boot:
pkg install baux-base baux bwm bterm bvi bweb chaos

# Enable BAUX keymap
echo 'keymap="baux"' >> /etc/rc.conf

# Enable services
echo 'baux_enable="YES"' >> /etc/rc.conf
echo 'bauxwm_enable="YES"' >> /etc/rc.conf
```

### 3. First Run Configuration
```bash
# Start BAUX environment
baux

# Your session appears:
# 1:shell  2:edit  3:web  4:——  5:——  6:——  7:——  8:——  9:——          15:33

# Press Mod4+2 to start editing
# Press Mod4+3 to open browser
```

## Package Details

### baux-base
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
- Fallback to vim → vi.tiny
- Session state persistence
- LSP for embedded development

**Usage:**
```bash
bvi file.c           # Opens with neovim
bvi --fallback file.c  # Forces vim if neovim unavailable
```

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