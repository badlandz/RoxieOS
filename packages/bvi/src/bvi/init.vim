" BVI Neovim Entrypoint - v0.1
" Bridges to custom Kickstart.nvim-forked Lua config in /etc/bvi/nvim/lua/bvi
" Loads core for immortality, AI/DB stubs, tmux sync—system-wide priority.

set nocompatible  " Disable vi compatibility for modern features (essential for plugins/Lua)

" Prepend system-wide config dir to runtimepath (prioritizes /etc over user ~/.config)
set runtimepath^=/etc/bvi/nvim

" Safely load the Lua core module (assumes /etc/bvi/nvim/lua/bvi/core/init.lua)
lua <<EOF
local ok, err = pcall(require, 'bvi.core')
if not ok then
  vim.notify("BVI: Failed to load core: " .. err, vim.log.levels.ERROR)
end
EOF
