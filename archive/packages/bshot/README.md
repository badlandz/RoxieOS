# bshot - Screenshot Tool
**BAUXBSD screenshot utility**

Press **Mod4+s** once. Get a perfect PNG. Works everywhere.

## Features

- **Universal**: Works in X11 and console framebuffer
- **Consistent**: Same keybinding across all BAUX layers
- **Simple**: No dialogs, no clipboard prompts
- **Organized**: Timestamped files in `~/shots/`

## Usage

```bash
bshot                    # Full screen
bshot window              # Select window/region
bshot --help             # Show options
```

## Output

```
~/shots/baux_YYYY-MM-DD_HHMMSS.png
```

## Dependencies

- **X11**: maim, xclip
- **Console**: fbgrab  
- **Total**: <8MB

bshot provides instant screenshots across all BAUXBSD environments.