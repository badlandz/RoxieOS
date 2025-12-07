# BAUXBSD Usage Guide
**Workstation Cloning and Daily Workflows**

## Workstation Cloning Workflow

### Backup Current Workstation
```bash
# On your current machine: Backup sessions, projects, configs to USB
baux-backup /mnt/usb/workstation-backup
```

### Boot New Machine and Clone
```bash
# Boot new laptop with BAUXBSD USB
# Install core packages
pkg install bbase baux bwm bterm bvi bweb chaos

# Clone your workstation
baux-clone /mnt/usb/workstation-backup
```

## Daily Workflows

### Development Session
```bash
# Start BAUX environment
baux

# Switch sessions: Mod4+1-9
# Navigate: hjkl everywhere
# Edit: bvi file.c
# File browser: <leader>pv
# Git: <leader>lg (lazygit)
# Tasks: <leader>tw (taskwiki)
```

### Session Resurrection
```bash
# Save current state
baux save

# Restore on any machine
baux revive --all
```

## Keybindings Reference

See Configuration.md for unified keymap system.

## Troubleshooting

### Keymap Issues
```bash
# Verify keymap
dumpkeys | grep -i escape
setxkbmap -print | grep baux
```

### Session Problems
```bash
# List sessions
baux list

# Kill broken session
baux kill session-name
```

## Examples

### Hardware Development
- Edit firmware in bvi
- Cross-compile in tmux pane
- Monitor serial output
- Upload via Arduino CLI

### Web Development
- Edit in bvi with LSP
- Browser in bweb
- Terminal in bterm

---

See also: Installation.md, Configuration.md, Packages.md