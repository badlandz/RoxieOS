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

`chaos` is a 30-line bash script that turns your perfectly organized, immortal BAUX session into a constantly shifting, pane-resizing, color-flashing, status-bar-scrambling light show the moment you look away.

Nothing ever stays in the same place long enough to burn pixels.

And when you press **any key**, it instantly snaps back to your real layout — exactly as resurrect left it.

### What It Looks Like

- Panes explode, shrink, rotate, swap places every few seconds
- `btop` in blood red
- `cmatrix` raining green code
- `fastfetch` with the giant Roxanne logo flashing colors
- Status bar disappears → reappears upside-down → screams “ROXANNE WAS HERE” in neon → vanishes again
- Every element moves, so no pixel is ever static

It looks like you left a quantum computer running a brute-force attack on reality.

It is the **perfect screensaver** for a distro that greets you with “You just got Roxanne’d” on the GRUB screen.

### How It Works (The Hack)

1. Triggered by idle detection (BAUX idle daemon or tmux `activity-action` — coming soon)
2. `tmux source-file /usr/share/baux/screensaver/chaos.conf` (optional — hides status bar completely)
3. `chaos.sh` runs in a hidden pane and just spams:
   - `split-window` with random percentages
   - `swap-pane`, `rotate-window`, `resize-pane`
   - Random commands (`btop`, `cmatrix`, `fastfetch`, `git log --graph`, etc.)
   - Status bar toggled on/off with random colors and messages
4. Any keypress → `tmux source-file /usr/share/baux/tmux/baux.conf` → everything instantly returns to your real layout

No external dependencies.  
No Hollywood bloat.  
Pure tmux violence.

### Installation

```bash
apt install chaos   # pulls in nothing but this script
# Then bind it (example):
bind -n M-S run-shell "tmux new-window -n chaos '/usr/share/baux/screensaver/chaos.sh'"
