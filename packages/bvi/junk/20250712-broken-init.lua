-- Set leader key
vim.g.mapleader = " "

-- Basic Neovim settings
vim.opt.guicursor = ""
vim.opt.syntax = "on"
vim.opt.tabstop = 4
vim.opt.filetype = "on"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.spell = false
vim.opt.ruler = true
vim.opt.list = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.laststatus = 2
vim.opt.foldenable = false
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Neovide settings
vim.g.neovide_transparency = 0.5
vim.g.transparency = 0.8
vim.g.neovide_background_color = "#0f1117" .. string.format("%x", math.floor(255 * vim.g.transparency))
vim.opt.guifont = "CaskaydiaCove Nerd Font:h13"

-- Colorscheme
vim.cmd("colorscheme industry")

-- Transparent background
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})



-- Plugin specifications
require("lazy").setup({
  { "folke/tokyonight.nvim", branch = "main" },
  { "morhetz/gruvbox" },
  { "preservim/nerdtree" },
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  { "vimwiki/vimwiki" },
  { "tbabej/taskwiki" },
  { "farseer90718/vim-taskwarrior" },
  { "plasticboy/vim-markdown" },
  { "powerman/vim-plugin-AnsiEsc" },
  { "majutsushi/tagbar" },
  { "tpope/vim-fugitive" },
  { "cormacrelf/vim-colors-github" },
  { "sonph/onehalf", rtp = "vim" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "xiyaowong/transparent.nvim" },
}, {
  install = { colorscheme = { "industry" } },
})

-- Keymappings for Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- NERDTree keymapping
vim.keymap.set("n", "<C-f>", ":NERDTreeToggle<CR>", {})

-- TaskWiki keymapping
vim.keymap.set("n", "<C-l>", ":TaskWikiToggle<CR>", {})

-- Fugitive keymappings
vim.keymap.set("n", "<leader>gf", ":diffget //2<CR>", {})
vim.keymap.set("n", "<leader>gj", ":diffget //3<CR>", {})
vim.keymap.set("n", "<leader>gs", ":G<CR>", {})

-- VimWiki configuration
vim.g.vimwiki_list = {
  {
    path = "~/doc/",
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

-- Airline configuration
vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = "raven"

-- Enable spell checking for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
})
