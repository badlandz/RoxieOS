# BAUXBSD Unified Keymap Philosophy
**Consistent muscle memory across all layers**

## Core Principle

> **One finger movement = one meaning = one result**  
No matter if you're in bwm, tmux, neovim, or console - the same keybindings produce identical results.

## The BAUX Keymap System

### Foundation: baux.kbd
**Location**: `/usr/share/syscons/keymaps/baux.kbd`  
**Purpose**: Caps Lock → Escape globally, Mod4 mappings for session switching

### Keymap Hierarchy

| Layer | Modifiers | Session Navigation | Window/Pane Nav | Global Actions |
|--------|------------|-------------------|------------------|----------------|
| **Console** | Ctrl-Alt | Mod4+1-9 (F1-F9) | Alt+1-9 | Ctrl+... |
| **bwm** | Mod4 | Mod4+1-9 | Alt+1-9 | Mod4+Enter/b |
| **tmux** | Ctrl-b (prefix) | Mod4+1-9 | Alt+1-9, hjkl | Ctrl+b |
| **bvi** | Space (leader) | Space+1-9 | hjkl, Ctrl+... | Space+... |

## Unified Keybindings

### Session Management (Universal)
```bash
Mod4+1-9        # Jump to session 1-9
Mod4+0            # Session dashboard
Mod4+b            # Toggle session display
```

### Navigation (Universal)
```bash
hjkl              # Cursor/pane/window navigation  
Alt+hjkl          # tmux windows
Mod4+hjkl          # bwm tags/virtual desktops
Ctrl+hjkl          # Vim cursor
```

### Editor Integration

### Neovim High-Productivity Keymaps
Based on community research and BAUX philosophy:

#### Leader System
```lua
-- Space is leader (consistent, easy to reach)
vim.g.mapleader = " "
```

#### Quick Access (inspired by VS Code/intellij)
```lua
-- File operations (Space+f)
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

-- Navigation (Space+e)
vim.keymap.set('n', '<leader>fe', builtin.file_browser, {})
vim.keymap.set('n', '<leader>er', builtin.recent_files, {})

-- Search/Replace (Space+s)
vim.keymap.set('n', '<leader>fs', builtin.current_search_fuzzy, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})

-- Git integration (Space+g)
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
```

#### Window Management
```lua
-- Split navigation (Ctrl+hjkl - consistent with tmux)
vim.keymap.set('n', '<C-h>', vim.cmd.wincmd('h'))
vim.keymap.set('n', '<C-j>', vim.cmd.wincmd('j'))
vim.keymap.set('n', '<C-k>', vim.cmd.wincmd('k'))
vim.keymap.set('n', '<C-l>', vim.cmd.wincmd('l'))

-- Buffer switching (Alt+1-9 - consistent with tmux)
vim.keymap.set('n', '<leader>1', function() vim.cmd.buffer(1) end, {})
vim.keymap.set('n', '<leader>2', function() vim.cmd.buffer(2) end, {})
-- ... up to 9
```

#### Terminal Integration
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
```bash
# Mod4+1-9 switches bwm tags (same as tmux sessions)
# Mod4+b toggles bwm status bar (same as tmux status)
# Mod4+Enter spawns bterm (new terminal)
```

### tmux Integration  
```bash
# Alt+1-9 switches tmux windows
# Mod4+1-9 switches tmux sessions (when BAUXWM unset)
# Mod4+b toggles tmux status line (when BAUXWM unset)
```

### Console Integration
```bash
# Mod4 mapped to Ctrl+Alt for session switching
# Caps→Esc handled by baux.kbd
# Ctrl+Alt+F1-F9 for TTY switching (same as Mod4+1-9)
```

## Advanced Features

### Multi-Monitor Support
```bash
# Session-per-monitor: Mod4+1-3 for monitor 1, Mod4+4-6 for monitor 2
# Cross-monitor window movement: Mod4+Shift+hjkl
```

### Emergency Recovery
```bash
Mod4+Escape      # Emergency reset to session 1
Mod4+Shift+R    # Hard reset of all sessions
```

## Implementation Notes

### baux.kbd Modifications
- Map Caps Lock to Escape
- Map Mod4 (Super/Windows key) to session switching
- Preserve Alt for application-specific actions
- Maintain Ctrl for universal actions

### Environment Variables
```bash
BAUXWM=1         # Indicates bwm is running
BAUX_SESSION=1     # Current session number
BAUX_LEADER=" "    # Space key in neovim
```

This unified keymap system ensures maximum productivity while maintaining consistency across all BAUXBSD components.