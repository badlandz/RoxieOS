# Plugins Directory

## Overview

This directory contains plugin configurations for LazyVim and custom additions. Each .lua file defines a plugin spec with options, keys, and dependencies. Plugins are managed by lazy.nvim for efficient loading.

## Core LazyVim Plugins (Inherited)
- **UI**: lualine (statusline), noice (notifications), which-key (hints)
- **Editing**: nvim-treesitter (syntax), nvim-cmp (completion), conform (formatting)
- **Tools**: telescope (fuzzy), gitsigns (Git), mason (LSP), trouble (diagnostics)
- **See lazy-lock.json for versions**

## Custom Plugin Files

### cmp.lua
- **Plugin**: nvim-cmp (completion)
- **Customization**: Remap Tab to trigger completion.
- **Why**: Better UX than default <C-Space>.

### colorscheme.lua
- **Plugin**: gruvbox.nvim (fallback)
- **Customization**: Set "biohazard" as default colorscheme.
- **Why**: Custom industrial theme.

### dadbod.lua
- **Plugins**: vim-dadbod-ui, vim-dadbod, vim-dadbod-completion
- **Features**: Database UI, connections, SQL completion.
- **Commands**: :DBUI, :DB
- **Why**: In-editor database work.

### lazygit.lua
- **Plugin**: lazygit.nvim
- **Keymap**: <leader>lg to open LazyGit.
- **Why**: Terminal Git UI integration.

### mini.lua
- **Plugin**: nvim-mini/mini.files
- **Keymap**: <leader>pv to toggle explorer.
- **Why**: Lightweight file browser.

### persistence.lua
- **Plugin**: persistence.nvim
- **Keymaps**: <leader>qs/ql/qd for session management.
- **Why**: Auto-save/restore sessions.

### undotree.lua
- **Plugin**: undotree
- **Keymap**: <leader>u to toggle.
- **Why**: Visual undo history.

### vimwiki.lua
- **Plugins**: vimwiki, taskwiki, vim-taskwarrior, vim-markdown
- **Features**: Wiki in ~/src/doc/, TaskWiki integration, spellcheck.
- **Keymap**: <leader>tw for TaskWiki.
- **Why**: Note-taking and task management.

## Management
- Add new plugins as .lua files with specs.
- Use :Lazy for updates/sync.
- Pin versions in lazy-lock.json.