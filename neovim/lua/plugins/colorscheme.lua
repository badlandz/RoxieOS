-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  -- Gruvbox for unified BAUXBSD theming
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load your colorscheme by default
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "delek",
      colorscheme = "gruvbox",
    },
  },
}
