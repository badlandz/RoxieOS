# BAUXBSD Usage Guide
**Workstation Cloning and Daily Workflows**

This guide supports the core vision of getting you to your code with the best vi/tools on any broken system via USB boot to IDE in 5 seconds.

## Workstation Cloning Workflow

### Backup Current Workstation
```bash
# On your current machine: Backup sessions, projects, configs to USB
baux-backup /mnt/usb/workstation-backup
```

### Boot New Machine and Clone
```bash
# Boot new laptop with RoxieOS USB
# LAN probing: Scans port 9999 for local BAUX sessions; offers login/clone if found
# Phone home: Connect to baux-scale server for full mesh session list

# Install core packages
pkg install bbase baux bwm bterm bvi bweb chaos

# Clone your workstation or resurrect from mesh
baux-clone /mnt/usb/workstation-backup
# Or: Select session from LAN/mesh and resurrect
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

### Session Management
```bash
# Interactive session selector (TUI)
baux sessions

# Switch to specific session
baux switch session-name

# Quick session switch (hostname-1, hostname-2, etc.)
baux 1  # Switch to hostname-1
baux 2  # Switch to hostname-2

# Pull remote session
baux pull remote-host session-name

# Push current session to mesh
baux push
```

### AI Assistant (baux-bot)
```bash
# Interactive AI chat
baux-bot

# Direct query
echo "How do I list files in bash?" | baux-bot

# Switch backends
baux-bot
> switch grok
> switch gemini
> switch ollama

# Available backends: ollama, grok, gemini, claude, replicate, together, huggingface
# Plus fun features: ascii-art, cheerleader, keystroke-guru
```

### Session Problems
```bash
# List all tmux sessions
tmux list-sessions

# Kill broken session
tmux kill-session -t session-name

# Clean start (kill all tmux servers)
tmux kill-server
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