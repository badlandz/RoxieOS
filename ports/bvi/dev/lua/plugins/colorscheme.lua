-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  -- Add the plugin for your desired colorscheme here, for example:
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load your colorscheme by default
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "delek",
      colorscheme = "biohazard",
    },
  },
}
