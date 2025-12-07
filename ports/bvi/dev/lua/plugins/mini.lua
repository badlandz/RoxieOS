return {
  {
    "nvim-mini/mini.files",
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
    },
    keys = {
      { "<leader>pv", function() require("mini.files").open() end, desc = "Open Mini Files" },
    },
  },
}