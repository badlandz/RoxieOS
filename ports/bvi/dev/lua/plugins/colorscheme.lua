-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
   -- Gruvbox for unified BAUXBSD theming (dev mode)
   { "ellisonleao/gruvbox.nvim" },

   -- Configure LazyVim to load gruvbox by default
   {
     "LazyVim/LazyVim",
     opts = {
       colorscheme = "gruvbox",
     },
   },
}
