# BAUX/RoxieOS Installation Guide
**FreeBSD-based immortal terminal environment**

## Current Implementation Status

**✅ Available Now:**
- `bbase` - BAUX keymap (Caps→Esc)
- `baux` - Session management with tmux
- `bvi` - Neovim wrapper with Gruvbox theme

**🚧 In Development:**
- `bwm` - Window manager (dwm-based)
- `chaos` - Screensaver
- Live USB persistence
- Full ecosystem packages

## Fresh FreeBSD Installation (Recommended)

### Step 1: Install FreeBSD 15.0
1. Download FreeBSD 15.0 installation media from https://www.freebsd.org/where/
2. Boot from installation media (USB or CD/DVD)
3. Select "Install" from the boot menu
4. Choose keyboard layout and hostname
5. Select disk and partitioning (use auto ZFS for simplicity)
6. Create user account with wheel group membership
7. Complete installation and reboot

### Step 2: Post-Installation Setup
```bash
# Login as your user account (not root)

# Update system packages
doas pkg update && doas pkg upgrade -y

# Install required packages for BAUX
doas pkg install -y bash git neovim tmux xterm

# Configure doas for your user (replace 'username' with your actual username)
echo "permit nopass username" | doas tee -a /usr/local/etc/doas.conf

# Clone BAUX repository
git clone https://github.com/badlandz/RoxieOS.git
cd RoxieOS

# Run BAUX installation
./scripts/install-baux-manual.sh
```

### Alternative: Automated Installation
```bash
# For automated setup (includes all dependencies)
./scripts/install-baux-unified.sh
```

### Quick Setup Script (Recommended for New Users)
```bash
# Automated system preparation and repository setup
./scripts/setup-baux-system.sh

# Then run installation
./scripts/install-baux-manual.sh
```

### Install BAUX Components
```bash
# Clone the repository
git clone https://github.com/badlandz/RoxieOS.git
cd RoxieOS

# Configure doas (required for installation)
echo "permit nopass :wheel" >> /usr/local/etc/doas.conf

# Run the unified installer (creates detailed log)
./scripts/install-baux-unified.sh

# Alternative: Run debug script first if issues occur
./scripts/debug-baux.sh

# Test the installation
./scripts/test-baux.sh
```

### Expected Results
```bash
# Keymap active (Caps Lock → Escape)
doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd

# Session manager works
baux --help

# Editor launches with Gruvbox theme
bvi test.txt
```

## Package Details

### bbase (✅ Implemented)
**Purpose:** System foundation with BAUX keymap
**Size:** ~1MB installed
**Files:**
- `/usr/share/syscons/keymaps/baux.kbd` - Console keymap
- `/etc/rc.conf` - System configuration

**Key Features:**
- Caps Lock → Escape globally
- FreeBSD syscons keymap integration

**Installation:**
```bash
cd ports/bbase
doas ./install.sh
doas sysrc keymap="baux"
```

### baux (✅ Implemented)
**Purpose:** Shell and session management
**Size:** ~5MB installed
**Dependencies:** tmux, neovim

**Key Features:**
- Immortal tmux sessions with TPM resurrection
- Anti-nesting detection
- Gruvbox theming throughout
- Ctrl+Space prefix for tmux commands

**Configuration:**
```bash
# Main tmux config
/usr/local/share/tmux/baux.conf

# TPM plugins auto-install
# Session resurrection enabled
```

**Usage:**
```bash
baux                    # Start BAUX session
baux --help            # Show help
Ctrl+Space + ?         # Tmux help
```

### bvi (✅ Implemented)
**Purpose:** Editor with intelligent fallback
**Size:** ~50MB installed
**Dependencies:** neovim

**Key Features:**
- Neovim with LazyVim integration
- Gruvbox color scheme
- Fallback: vim → vi.tiny
- Isolated config (NVIM_APPNAME=bvi)

**Configuration:**
```bash
# Neovim config
/usr/local/etc/bvi/init.vim

# Fallback vim config
/usr/local/etc/bvi/vimrc.tiny

# Shared lua configs
/usr/local/share/bvi/lua/
```

**Usage:**
```bash
bvi file.c           # Opens with neovim + Gruvbox
bvi --version        # Shows neovim version
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
# Start BAUX environment
baux                    # Opens tmux with BAUX config

# Within tmux (Ctrl+Space prefix):
Ctrl+Space + c          # New window
Ctrl+Space + 1          # Switch to window 1
Ctrl+Space + %          # Split vertically
Ctrl+Space + "          # Split horizontally
Alt+h/j/k/l             # Navigate panes
```

### Accessibility Features
BAUX includes comprehensive accessibility support:

**Font Configuration:**
- Console fonts automatically set to large, readable sizes
- X11 fonts configured with 192 DPI for 20pt effective text
- Resolution limited to 1920x1280 to prevent tiny fonts

**Backup Terminal:**
- xterm with guaranteed 20pt fonts always available
- Independent of main BAUX configuration
- Use: `./scripts/launch-backup-terminal.sh`

**Emergency Fixes:**
- `./scripts/emergency-font-fix.sh` - Try everything to fix fonts
- `./scripts/quick-accessibility-fix.sh` - Immediate font fixes

### Editor Integration
```bash
# Edit files with bvi
bvi main.c              # Opens in neovim with BAUX configuration
bvi README.md           # Same editor, consistent theme

# Tmux integration
baux                    # Start BAUX environment (Ctrl+Space prefix)
Ctrl+Space + :          # Tmux command mode
:neww bvi file.c        # Open editor in new window
```

### Session Persistence
```bash
# Sessions auto-save every 5 minutes (continuum)
# Manual save/restore via TPM resurrect plugin
Ctrl+Space + Ctrl+s     # Save current session
Ctrl+Space + Ctrl+r     # Restore saved session
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
ls -la /usr/share/syscons/keymaps/baux.kbd

# Test keymap loading
doas kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd

# Check system keymap setting
grep keymap /etc/rc.conf

# Reset if needed
doas sysrc keymap="us"
doas kbdcontrol -l /usr/share/syscons/keymaps/us.kbd
```

### Session Problems
```bash
# Check tmux installation
tmux -V

# Verify baux config
ls -la /usr/local/share/tmux/baux.conf

# Test tmux directly
tmux -f /usr/local/share/tmux/baux.conf

# Check TPM installation
ls -la /usr/local/share/tmux/plugins/tpm/
```

### Editor Issues
```bash
# Check bvi installation
ls -la /usr/local/bin/bvi

# Verify configs
ls -la /usr/local/etc/bvi/
ls -la /usr/local/share/bvi/

# Test neovim directly
nvim --version

# Check if configs load
bvi --headless -c "echo 'Config loaded'" 2>/dev/null
```

### Installation Debugging
```bash
# The unified installer creates a detailed log file automatically
# Check the log file mentioned in the output for full diagnostics

# Run the debug script for additional diagnostics
./scripts/debug-baux.sh

# Check doas configuration
doas whoami

# Test individual component installation (if unified installer fails)
cd ports/bbase && doas ./install.sh
cd ../baux && doas ./install.sh
cd ../bvi && doas ./install.sh

# Verify file permissions
ls -la /usr/local/bin/baux
ls -la /usr/local/share/tmux/baux.conf
ls -la /usr/share/syscons/keymaps/baux.kbd

# Check the installation log for detailed error information
ls -la baux-install-*.log
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