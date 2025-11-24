" BAUXVI Neovim Entrypoint - v0.1
" Loads custom NvChad-derived Lua config from /etc/bauxvi/nvim/lua/bauxvi

set nocompatible  " Enable modern Vim features (essential for plugins)

" Prepend our config dir to runtimepath for system-wide priority
set runtimepath^=/etc/bauxvi/nvim

" Load the Lua core module (assumes /etc/bauxvi/nvim/lua/bauxvi/core/init.lua or core.lua)
lua <<EOF
local ok, err = pcall(require, 'bauxvi.core')
if not ok then
  vim.notify("BAUXVI: Failed to load core: " .. err, vim.log.levels.ERROR)
end
EOF
