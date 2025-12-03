# bbase - System Foundation
**BAUXBSD core system configuration**

`bbase` provides the fundamental system setup for BAUXBSD, including the custom keymap and basic configurations.

## Features

- **baux.kbd keymap**: Caps Lock → Escape globally
- **System configurations**: Root autologin, service setup
- **rc.d integration**: FreeBSD service management
- **Minimal footprint**: Core system utilities only

## Package Structure

```
bbase/
├── Makefile          # FreeBSD port build
├── pkg-descr         # Package description
├── pkg-plist         # Installation manifest
└── files/
    └── usr/share/syscons/keymaps/baux.kbd
```

## Installation

```bash
pkg install bbase
# Automatically configures:
# - Console keymap (Caps→Esc)
# - X11 keymap integration
# - System services
```

## Configuration

After installation, the system will have:
- **Console keymap**: `keymap="baux"` in `/etc/rc.conf`
- **X11 integration**: BAUX keymap available for X sessions
- **Service management**: rc.d scripts for BAUX components

bbase provides the foundation that makes BAUXBSD's unified keybindings work across all layers.