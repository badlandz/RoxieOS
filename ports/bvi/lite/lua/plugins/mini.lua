return {
  {
    "echasnovski/mini.files",
    version = false,
    config = function()
      require("mini.files").setup({
        windows = {
          preview = true,
          width_preview = 80,
        },
      })
    end,
  },

  -- tmux integration for seamless navigation (simple, effective)
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,  -- Load immediately for keybindings to work
  },
}