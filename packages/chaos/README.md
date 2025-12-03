# chaos - Anti-Burn-In Screensaver
**BAUXBSD screen protection**

`chaos` prevents screen burn-in by creating dynamic, moving visual effects when the system is idle.

## Purpose

- **Burn-in prevention**: No pixel stays static for extended periods
- **Instant recovery**: Any keypress restores exact session state
- **Minimal footprint**: ~1MB, pure tmux scripting

## Features

- **Idle activation**: Triggers after 15 minutes of inactivity
- **Manual trigger**: Instant activation via Mod4+c
- **Dynamic effects**: Random pane resizing, color changes, status scrambling
- **Zero configuration**: Works out of the box

## Package Structure

```
chaos/
├── files/
│   └── usr/local/bin/chaos   # Main script
└── Makefile                     # FreeBSD port
```

## Effects

- **Pane chaos**: Random splits, swaps, rotations
- **Color cycling**: btop in red, cmatrix green, fastfetch flashing
- **Status manipulation**: Bar appears/disappears with random messages
- **Terminal effects**: git graphs, system monitors, animated text

## Integration

- **baux**: Session state preservation
- **bwm**: Idle detection and trigger
- **tmux**: Visual effect rendering

chaos ensures BAUXBSD systems can run 24/7 without screen damage while maintaining instant productivity restoration.