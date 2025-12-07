# bvi - Immortal Editor Wrapper
**BAUXBSD v0.1 editor with intelligent fallback**

`bvi` provides a unified editing experience from vi.tiny to full Neovim, with session persistence and intelligent feature detection.

## Three Operating Modes

### 1. vi.tiny Fallback
- **When**: Minimal systems or rescue scenarios
- **Features**: Basic immortality with SeaweedFS stubs
- **Size**: <2MB

### 2. vim Stable Mode
- **When**: Default BAUXBSD installation
- **Features**: Full autocmds, undotree, basic AI pipes
- **Size**: ~5MB

### 3. Neovim Full Power
- **When**: Development environments
- **Features**: LSP, Lazy.nvim, AI integration, tmux harmony
- **Size**: ~10MB + plugins

## Package Structure

```
bvi/
├── src/bvi.sh              # Main wrapper script
├── files/
│   └── usr/local/etc/bvi/
│       ├── init.lua        # Neovim config
│       └── vimrc.tiny     # vi fallback
└── Makefile               # FreeBSD port
```

## Integration

- **baux**: Session state persistence
- **bwm**: Editor keybinding consistency
- **bbot**: AI assistant integration

## Usage

```bash
bvi file.c           # Opens with appropriate editor
bvi --fallback file.c  # Force specific editor level
bvi --level neovim   # Force Neovim mode
```

## Conflict Resolution

**Intentionally replaces editors/bvi** - the basic binary editor. Our enhanced version provides:

- Neovim integration with Lazy.nvim
- Intelligent fallback chain
- Binary editing via original bvi
- Session persistence and BAUX integration

**Installation Note:** Will replace existing `editors/bvi` if installed.

bvi ensures your editing environment follows you across any BAUXBSD system, from rescue USB to development workstation.