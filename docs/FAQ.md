# BAUXBSD FAQ
**Frequently Asked Questions**

## General

### What is BAUXBSD?
BAUXBSD is a minimal FreeBSD-based operating system focused on instant workstation cloning and persistent sessions. It provides a unified environment where your exact development setup resurrects on any hardware in seconds.

### Why FreeBSD?
FreeBSD offers superior ZFS support, ports system for clean packaging, and a focus on correctness over features. It's ideal for embedded and workstation scenarios.

### What's the difference from regular FreeBSD?
BAUXBSD adds:
- Caps Lock → Escape globally
- Immortal tmux sessions
- Unified keybindings across console/X/tmux/editor
- Workstation cloning capabilities
- Minimal, focused package set

## Installation

### How do I install BAUXBSD?
1. Boot from USB with FreeBSD 15.0
2. `pkg install bbase baux bwm bterm bvi bweb chaos`
3. Enable services and keymap
4. Clone your workstation with `baux-clone`

### Can I install on existing FreeBSD?
Yes, BAUXBSD packages are designed to work on standard FreeBSD installations.

## Usage

### How does workstation cloning work?
- Backup: `baux-backup /path/to/usb`
- Restore: Boot new machine, `baux-clone /path/to/backup`
- Your sessions, projects, and configs restore instantly.

### What are the keybindings?
- Mod4+1-9: Switch sessions everywhere
- Alt+1-9: Switch tmux windows
- hjkl: Navigation in all layers
- Caps Lock: Escape globally

See Configuration.md for complete reference.

### How do I get AI assistance?
BAUXBSD provides multi-model AI assistance for development:
- **Local AI (Ollama)**: `baux-bot` - Context-aware chat with real-time repo monitoring
- **Cloud AI (xAI Grok)**: `dev-assist`, `xai-chat`, `grok-workshop` - Development and general chat
- **Cloud AI (Google Gemini)**: `dev-gemini`, `gemini-chat` - Alternative cloud assistance (paid quota required)
- **Keybindings**: Alt+b (tmux) launches baux-bot; <leader>b (neovim) for AI help
- **Setup**: Set `GROK_API_KEY`, `GEMINI_API_KEY` in `~/.bashrc`; Ollama auto-configured
- **Model Switching**: `baux-bot` supports dynamic Ollama ↔ Grok switching

## Troubleshooting

### Keymap not working?
```bash
# Check console keymap
kbdcontrol -l /usr/share/syscons/keymaps/baux.kbd

# Check X11
setxkbmap -symbols baux
```

### Sessions not resurrecting?
- Ensure SeaweedFS is running
- Check ZFS snapshots: `zfs list -t snapshot`
- Try manual revive: `baux revive --all`

### Performance issues?
- Core packages use <400MB total
- Boot time <5 seconds
- Memory <200MB idle

## Development

### How do I contribute?
- See Development.md for roadmap
- Packages are in ports/ directory
- Use FreeBSD ports conventions
- Test on multiple architectures

### What's planned for future versions?
- v0.2: Full SeaweedFS persistence
- v1.0: AI-powered development environment
- Complete digital twin implementation

## Hardware

### What hardware is supported?
- amd64: Modern laptops/desktops
- aarch64: Raspberry Pi, Pine64
- Legacy: 32-bit systems for rescue

### Minimum requirements?
- 512MB RAM (Pi Zero compatible)
- Any storage with ZFS support
- USB boot capability

---

See also: Installation.md, Usage.md, Configuration.md