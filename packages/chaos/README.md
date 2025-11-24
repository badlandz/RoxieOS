# This Is Chaos

## chaos — The Rick-Roll Anti-Burn-In Screensaver for RoxieOS / BAUX

**File:** `/usr/share/baux/screensaver/chaos.sh`  
**Package:** `chaos` (optional, but part of the full Rick-Roll experience)

### Why This Exists

Old LCDs, cheap HDMI monitors, CRTs, OLEDs — they all burn in if you leave a static tmux status bar or btop grid on for hours.

RoxieOS is meant to be left running 24/7 on random hardware you found in a drawer, plugged into a TV in the corner of the room, or bolted to the wall above your soldering station.

So we don’t do “pretty static dashboard”.

We do **controlled chaos**.

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
