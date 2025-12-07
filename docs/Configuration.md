# BAUXBSD Unified Workflow & Keymap Philosophy

## Core Principle: One Finger Movement = One Meaning

Every key combination produces identical results across all BAUXBSD layers.

## The BAUX Keymap System

### Foundation: baux.kbd
**Location:** `/usr/share/syscons/keymaps/baux.kbd`
**Purpose:** Caps Lock → Escape globally, Mod4 session switching

### Keymap Hierarchy

| Layer | Modifiers | Session Navigation | Window/Pane Nav | Global Actions |
|--------|------------|-------------------|------------------|----------------|
| Console | Ctrl-Alt | Mod4+1-9 (F1-F9) | Alt+1-9 | Ctrl+... |
| bwm | Mod4 | Mod4+1-9 | Alt+1-9 | Mod4+Enter/b |
| tmux | Ctrl-b | Mod4+1-9 | Alt+1-9, hjkl | Ctrl+b |
| bvi | Space | Space+1-9 | hjkl, Ctrl+... | Space+... |

## Neovim High-Productivity Keymaps

Based on community research and BAUX philosophy:

### Leader System
```lua
vim.g.mapleader = " "  -- Space is leader (easy to reach)
```

### Quick Access (VS Code/intellij inspired)
```lua
-- File operations (Space+f)
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

-- Navigation (Space+e)
vim.keymap.set('n', '<leader>fe', builtin.file_browser, {})
vim.keymap.set('n', '<leader>er', builtin.recent_files, {})

-- Git integration (Space+g)
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
```

### Window Management
```lua
-- Split navigation (Ctrl+hjkl - consistent with tmux)
vim.keymap.set('n', '<C-h>', vim.cmd.wincmd('h'))
vim.keymap.set('n', '<C-j>', vim.cmd.wincmd('j'))
vim.keymap.set('n', '<C-k>', vim.cmd.wincmd('k'))
vim.keymap.set('n', '<C-l>', vim.cmd.wincmd('l'))

-- Buffer switching (Alt+1-9 - consistent with tmux)
vim.keymap.set('n', '<leader>1', function() vim.cmd.buffer(1) end, {})
-- ... up to 9
```

### Terminal Integration
```lua
-- tmux integration (Ctrl+b actions)
vim.keymap.set('n', '<C-b>s', ':!tmux new-window<CR>')
vim.keymap.set('n', '<C-b>w', ':!tmux previous-window<CR>')
vim.keymap.set('n', '<C-b>c', ':!tmux kill-pane<CR>')

-- Send to BAUX bot (Space+shift+b)
vim.keymap.set('v', '<leader>b', ':BauxSendBuffer<CR>')
vim.keymap.set('v', '<leader>l', ':BauxSendLine<CR>')
```

## Cross-Application Consistency

### bwm Integration
- Mod4+1-9 switches bwm tags (same as tmux sessions)
- Mod4+b toggles bwm status bar (same as tmux status)
- Mod4+Enter spawns bterm (new terminal)

### tmux Integration
- Alt+1-9 switches tmux windows
- Mod4+1-9 switches tmux sessions (when BAUXWM unset)
- Mod4+b toggles tmux status line (when BAUXWM unset)

### Console Integration
- Mod4 mapped to Ctrl+Alt for session switching
- Caps→Esc handled by baux.kbd
- Ctrl+Alt+F1-F9 for TTY switching (same as Mod4+1-9)

## Implementation Notes

### baux.kbd Modifications
- Map Caps Lock to Escape
- Map Mod4 (Super/Windows key) to session switching
- Preserve Alt for application-specific actions
- Maintain Ctrl for universal actions

### Environment Variables
```bash
BAUXWM=1         # Indicates bwm is running
BAUX_SESSION=1   # Current session number
BAUX_LEADER=" "  # Space key in neovim
```

## Neovim Integration

The bvi package includes comprehensive neovim keymaps aligned with BAUXBSD:

- **Leader**: Space (consistent with LazyVim)
- **Window Navigation**: `<C-hjkl>` (matches tmux)
- **Buffer Switching**: `<leader>1-9` (matches tmux Alt+1-9)
- **File Operations**: `<leader>pv` (mini.files), `<leader>ff/fg/fb` (telescope)
- **Tmux Integration**: `<C-b>` commands for pane/window management
- **BAUX Bot**: `<leader>b/l` in visual mode
- **Theme**: Gruvbox (unified with console, WM, terminal)

See `neovim/lua/config/keymaps.lua` for complete implementation.

## Gruvbox Theming System

**GruvBAUX Prototype** uses Gruvbox across all layers:

### Console
- vt(4) color theme: Gruvbox palette
- Consistent with terminal colors

### Window Manager (bwm)
- Window borders: Gruvbox accent colors
- Status bar: Gruvbox background with contrast
- Selected windows: Gruvbox bright colors

### Neovim
- Colorscheme: Gruvbox
- Status line: Gruvbox integration
- Consistent with tmux and terminal

### Tmux
- Status bar: Gruvbox colors
- Pane borders: Gruvbox accents
- Window indicators: Gruvbox highlights

This unified theming system ensures visual consistency while maintaining readability and the signature Gruvbox aesthetic.

This unified keymap and theming system ensures maximum productivity while maintaining consistency across all BAUXBSD components.