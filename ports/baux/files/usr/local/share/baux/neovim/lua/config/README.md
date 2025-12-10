# Config Directory

## Overview

This directory holds the core Neovim configuration files, overriding LazyVim defaults for customization. Files load in order: options.lua, autocmds.lua, keymaps.lua, lazy.lua.

## Files

### options.lua
- **Purpose**: Set Neovim options for behavior and appearance.
- **Key Settings**:
  - mouse=a: Mouse support in all modes
  - clipboard=unnamedplus: System clipboard integration
  - swapfile=false: Disable swap files for cleaner sessions
  - inccommand=split: Live preview for :%s commands
  - scrolloff=8, sidescrolloff=8: Context lines for scrolling
- **Inspired By**: bvi.nvim for performance tweaks.

### autocmds.lua
- **Purpose**: Define automatic commands for events.
- **Current**: Empty, with LazyVim comments for adding custom autocmds.
- **Example Usage**: Spellcheck in Markdown files (implemented in vimwiki.lua).

### keymaps.lua
- **Purpose**: Unified keybindings following BAUXBSD philosophy.
- **Structure**: Leader (Space), grouped mappings for navigation, operations, integration.
- **Key Features**: Window nav (<C-hjkl>), tmux commands (<C-b>), session controls (<leader>q).
- **See Also**: STATUS-KEYMAPS.md for full list.

### lazy.lua
- **Purpose**: Configure lazy.nvim and LazyVim.
- **Settings**: Lazy-loading, version pinning, install options (colorschemes, updates).
- **Performance**: Disables unused RTP plugins (gzip, tar, etc.).

## Customization
- Edit files for personal preferences.
- Restart Neovim or run `:source` to apply changes.
- Ensure compatibility with LazyVim defaults.