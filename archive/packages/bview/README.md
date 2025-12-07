# bview - Image Viewer
**BAUXBSD image viewing with sxiv**

`bview` provides keyboard-driven image viewing for BAUXBSD development environments.

## Features

- **Keyboard navigation**: hjkl movement, space to advance
- **Minimal interface**: No GUI clutter
- **Fast startup**: Instant image loading
- **Batch viewing**: Directory navigation

## Package Structure

```
bview/
├── files/
│   └── usr/local/bin/bview   # sxiv wrapper
└── Makefile                     # FreeBSD port
```

## Usage

```bash
bview image.jpg              # View single image
bview *.jpg                  # View all JPGs in directory
bview --help                 # Show options
```

## Keybindings

- **hjkl**: Navigate images
- **Space**: Next image
- **b**: Previous image
- **q**: Quit
- **r**: Rotate
- **f**: Fit to window

## Integration

- **baux**: Session integration for image workflows
- **bvi**: Image viewing from editor
- **bshot**: Screenshot viewing

bview provides essential image viewing capabilities for development and documentation workflows.