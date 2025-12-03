# bwm – Minimal Window Manager
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
| Alt+1-9 | tmux windows | Universal |

## Integration

- **baux**: Session names via BAUXWM=1 environment variable
- **bterm**: Terminal spawning with consistent theming
- **chaos**: Screensaver integration

bwm provides the visual layer that makes BAUX sessions instantly accessible without breaking muscle memory.

### Key Features

- **dwm-roxanne** – heavily patched suckless `dwm` with:
  - `Option + hjkl` → tag navigation (exactly one layer above tmux’s `Alt + hjkl` panes)
  - “Roxanne” theme (matches BAUX truecolor status bar) (you don't have to turn on the red light...)
  - Single-key shortcuts for Alacritty, volume, brightness, screenshots, etc.
- **Alacritty-roxanne** – pre-configured terminal with perfect font rendering, ligatures, and the exact same colors as your BAUX tmux sessions
- **picom** – subtle shadows + transparency so floating BAUX windows look like they belong
- **status.sh** – DWM status bar that pulls live info from your running BAUX session (time of day and battery only by default)
- **xinitrc** – `startx` → straight into the rice, no display manager required
- Full keyboard layout consistency (`/etc/default/keyboard`) so `Alt`, `Option`, and `Ctrl` behave exactly the same on console and X

### The Flow Ladder (Zero Context Switch)

| Layer       | Movement Keys       | Action
|-------------|---------------------|----------------------------------------
| Neovim      | `hjkl`              | cursor
| tmux        | `Alt + hjkl`        | panes
| dwm         | `Option + hjkl`     | tags / virtual desktops
| Global      | `Ctrl + …`          | universal prefix (tmux, system, etc.)

You never have to think about “which layer am I in?” again.

### Installation (30 seconds)

```bash
# On any Debian / Raspberry Pi OS / RoxieOS system
wget https://github.com/badlandz/bauxwm/packages/ ?
sudo apt install ./bauxwm_0.1.0_arm32.deb (eventually, only amd64 packages during testing)

# Then just
startx
