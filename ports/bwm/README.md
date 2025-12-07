# bwm - Minimal Window Manager
**BAUXBSD window management layer**

`bwm` is a minimal, keyboard-driven window manager based on dwm, designed for perfect integration with BAUX session management.

## Core Features

- **Session display**: Shows BAUX session names in status bar
- **Mod4 integration**: Mod4+1-9 switches sessions (same as tmux)
- **BAUXWM=1**: Environment variable controls tmux status visibility
- **Minimal footprint**: ~25MB installed
- **Keyboard-native**: No mouse required

## Package Structure

```
bwm/
├── files/
│   ├── usr/local/bin/dwm          # Patched dwm binary
│   └── usr/local/bin/status.sh   # Status bar script
├── patches/
│   └── baux.patch              # dwm patches for BAUX integration
└── Makefile                     # FreeBSD port build
```

## Keybindings

| Command | Action | Context |
|---------|---------|---------|
| Mod4+1-9 | Switch session | Universal |
| Mod4+hjkl | Navigate tags | X11 only |
| Mod4+Enter | New terminal | Universal |
| Mod4+b | Toggle status bar | Universal |

## Integration

- **baux**: Session names via BAUXWM=1 environment variable
- **bterm**: Terminal spawning with consistent theming
- **chaos**: Screensaver integration

## Status Bar

The bwm status bar shows:
- Current BAUX session names (when BAUXWM=1)
- System information (battery, time)
- Active window title

bwm provides the visual layer that makes BAUX sessions instantly accessible without breaking muscle memory.