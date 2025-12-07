# bvi - Immortal Editor Wrapper
**BAUXBSD editor with lite/dev variants**

`bvi` provides a unified editing experience with LazyVim, optimized for embedded development. Features lite mode for Pi Zero compatibility and dev mode for full workstations.

## Two Operating Modes

### 1. Lite Mode (Default)
- **Target**: Pi Zero, minimal systems
- **Features**: LazyVim core, persistence, mini.files, undotree, gruvbox theme
- **Size**: ~15MB + LazyVim
- **Plugins**: Essential for embedded workflow

### 2. Dev Mode (-dev package)
- **Target**: Development workstations
- **Features**: Full LazyVim ecosystem, vimwiki, dadbod, lazygit, taskwiki
- **Size**: ~50MB + plugins
- **Plugins**: Complete development environment

## Package Structure

```
bvi/
├── lite/                   # Pi Zero compatible config
│   ├── init.lua
│   └── lua/
│       ├── config/
│       └── plugins/
├── dev/                    # Full workstation config
│   ├── init.lua
│   └── lua/
│       ├── config/
│       └── plugins/
├── src/bvi.sh              # Main wrapper script
└── Makefile                # FreeBSD port
```

## Integration

- **baux**: Session state persistence
- **bwm**: Editor keybinding consistency
- **bbot**: AI assistant integration

## Usage

```bash
bvi file.c           # Opens with lite/dev config based on system
pkg install bvi-dev  # Install dev variant on workstations
```

## Configuration

- **Lite**: Optimized for low memory, fast startup
- **Dev**: Full development environment with all plugins
- **Keymaps**: Unified BAUXBSD system across all modes
- **Themes**: Gruvbox (lite), Biohazard (dev)

## Integration

- **baux**: Session persistence via folke/persistence
- **bwm**: Consistent keybindings and theming
- **bbot**: AI assistance integration
- **FreeBSD**: Native ports with nightly neovim

## Variants

- **bvi**: Lite mode for embedded systems
- **bvi-dev**: Full development mode for workstations

bvi provides a consistent editing experience across all BAUXBSD deployments, from Pi Zero to development workstations.