# BAUX Accessibility & Display Management

## Overview
BAUX includes comprehensive accessibility features and display management to ensure usability across different hardware and vision requirements.

## Font Configuration

### Console Fonts
BAUX automatically sets readable console fonts:

```bash
# In bbase installation
doas vidcontrol -f 8x16 /usr/share/syscons/fonts/TERMINAL_8x16.fnt
```

**Font Selection Criteria:**
- **Readability:** Clear, high-contrast characters
- **Size:** Minimum 8x16 pixels for impaired vision
- **Compatibility:** Works on all FreeBSD console types

### X11 Fonts
BAUX configures X11 for optimal readability:

```bash
# ~/.Xresources (auto-generated)
Xft.dpi: 120
Xft.antialias: true
Xft.hinting: true
Xft.hintstyle: hintslight
```

## Display Resolution Management

### Resolution Limiting
BAUX prevents tiny fonts on high-resolution displays:

```bash
# Maximum resolution enforcement
MAX_WIDTH=1920
MAX_HEIGHT=1080

# Auto-detect and limit display resolution
./scripts/setup-display.sh
```

### X300 ThinkPad Special Handling
The ThinkPad X300 requires special configuration:

```bash
# X300-specific resolution and aspect ratio
X300_NATIVE_RES="1024x768"
X300_ASPECT_RATIO="4:3"

# Custom font scaling for X300
X300_FONT_SIZE="12pt"
```

## Accessibility Features

### Vision Impairment Support
- **High DPI Fonts:** 120 DPI instead of default 96
- **Large Console Fonts:** 8x16 minimum
- **High Contrast Colors:** Improved visibility
- **Font Antialiasing:** Smooth text rendering

### Hardware-Specific Optimizations
- **X300 Display:** Custom resolution handling
- **Raspberry Pi:** Appropriate font sizing
- **High-DPI Displays:** Resolution limiting

## Implementation Details

### Automatic Detection
BAUX probes the system during installation:

```bash
# Display capability detection
DISPLAY_INFO=$(xdpyinfo 2>/dev/null || echo "console")
HARDWARE_MODEL=$(sysctl -n hw.model)

# Apply appropriate configuration
case "$HARDWARE_MODEL" in
    *"ThinkPad X300"*)
        apply_x300_config
        ;;
    *"Raspberry Pi"*)
        apply_rpi_config
        ;;
    *)
        apply_generic_config
        ;;
esac
```

### Configuration Persistence
Settings persist across reboots:

```bash
# /etc/rc.conf additions
keymap="baux"
allscreens_flags="MODE_1920x1080"  # Limit resolution

# ~/.Xresources (user-specific)
Xft.dpi: 120
```

## Testing & Verification

### Font Readability Test
```bash
# Console font check
vidcontrol -i active

# X11 font check
xrdb -query | grep Xft
```

### Resolution Verification
```bash
# Check current resolution
xdpyinfo | grep dimensions

# Verify limits applied
./scripts/verify-display.sh
```

## Troubleshooting

### Fonts Too Small
```bash
# Increase console font
doas vidcontrol -f 12x24 /usr/share/syscons/fonts/TERMINAL_12x24.fnt

# Increase X11 DPI
echo "Xft.dpi: 144" >> ~/.Xresources
xrdb ~/.Xresources
```

### Resolution Issues
```bash
# Manual resolution setting
doas vidcontrol MODE_1920x1080

# Check X300 specific settings
./scripts/setup-x300-display.sh
```

This ensures BAUX is usable by everyone, regardless of hardware or vision requirements.