return {
  { "vimwiki/vimwiki" },
  { "tbabej/taskwiki" },
  { "farseer90718/vim-taskwarrior" },
  { "plasticboy/vim-markdown" },

  {
    "vimwiki/vimwiki",
    config = function()
      -- VimWiki configuration
      vim.g.vimwiki_list = {
        {
          path = "~/src/doc/",
          syntax = "markdown",
          ext = ".md",
        },
      }
      vim.g.vimwiki_ext2syntax = {
        [".md"] = "markdown",
        [".markdown"] = "markdown",
        [".mdown"] = "markdown",
      }
      vim.g.vimwiki_markdown_link_ext = 1
      vim.g.vimwiki_folding = ""

      -- TaskWiki configuration
      vim.g.taskwiki_markup_syntax = "markdown"
      vim.g.taskwiki_disable_concealcursor = "nc"

      -- TaskWiki keymapping moved to config/keymaps.lua as <leader>tw

      -- Enable spell checking for Markdown files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = 'en_us'
        end,
      })
    end,
  },
}