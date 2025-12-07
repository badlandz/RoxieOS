-- Unified BAUXBSD Keymap Framework for Neovim
-- Aligns with console, bwm, tmux layers for "One Finger Movement = One Meaning"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader remains Space for consistency
vim.g.mapleader = " "

-- Window Navigation (matches tmux <C-hjkl>)
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)  -- Keep for redraw; no override

-- Resize Splits (arrows for accessibility)
map('n', '<C-Up>', ':resize +2<CR>', opts)
map('n', '<C-Down>', ':resize -2<CR>', opts)
map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Buffer Switching (<leader>1-9, consistent with tmux Alt+1-9)
for i = 1, 9 do
  map('n', '<leader>' .. i, function() vim.cmd('buffer ' .. i) end, opts)
end

-- File Operations (LazyVim provides <leader>ff/fg/fb/fe/er via Telescope)
-- Git Integration (LazyVim provides <leader>gs/gb/gc via Telescope)

-- LSP/Code Actions (<leader>c group, aligns with LazyVim)
map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
map('n', '<leader>rn', vim.lsp.buf.rename, opts)

-- Task/Wiki Integration (relocate from <C-l> to avoid conflict)
map('n', '<leader>tw', ':TaskWikiToggle<CR>', opts)

-- Visual Mode Enhancements
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)
map('v', '<leader>p', '"_dP', opts)  -- Paste without yank

-- Insert Mode (optional, since Caps→Esc global)
map('i', 'jk', '<ESC>', opts)

-- Tmux Integration (<C-b> prefix, enhanced for RoxieOS sync)
map('n', '<C-b>s', ':!tmux new-window<CR>', opts)
map('n', '<C-b>w', ':!tmux previous-window<CR>', opts)
map('n', '<C-b>c', ':!tmux kill-pane<CR>', opts)
map('n', '<C-b>%', ':!tmux split-window -h<CR>', opts)  -- Vertical split
map('n', '<C-b>"', ':!tmux split-window -v<CR>', opts)  -- Horizontal split
for i = 1, 9 do
  map('n', '<C-b>' .. i, ':!tmux select-window -t ' .. i .. '<CR>', opts)  -- Select window 1-9
end

-- BAUX Bot Integration (visual mode)
map('v', '<leader>b', ':BauxSendBuffer<CR>', opts)
map('v', '<leader>l', ':BauxSendLine<CR>', opts)
