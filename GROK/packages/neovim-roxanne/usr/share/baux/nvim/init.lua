-- RoxieOS BAUX Neovim Configuration v2.0
-- Robust, minimal, Pi Zero compatible
-- Includes bvi fallback and hooks for future -DEV features

-- Performance optimizations for low-end hardware
vim.loader.enable()

-- Leader key
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- Core UI and themes
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        palette_overrides = {
          dark0_hard = "#0e281c",  -- Roxanne dark green
        }
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },

  -- Minimal status line
  {
    "echasnovski/mini.statusline",
    version = "*",
    config = function()
      require("mini.statusline").setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = "MiniStatuslineLocation", strings = { location } },
            })
          end,
        },
        set_vim_settings = false,
      })
    end,
  },

  -- Vi fallback system (bvi.nvim)
  {
    dir = "/etc/bvi",  -- User specified location
    name = "bvi",
    config = function()
      -- Load bvi configuration
      require("bvi").setup({
        -- Fallback to vi when nvim fails
        fallback = true,
        -- Minimal features for low-end hardware
        features = {
          syntax = true,
          filetype = true,
          indent = true,
        },
      })
    end,
  },

  -- Treesitter for syntax highlighting (minimal)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "cpp", "lua", "python", "javascript",
          "json", "yaml", "markdown", "vim", "vimdoc"
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = false },  -- Disabled for performance
        textobjects = { enable = false },  -- Disabled for performance
      })
    end,
  },

  -- LSP support (lightweight)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure common LSP servers
      local servers = { "bashls", "clangd", "pyright", "lua_ls" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          capabilities = capabilities,
          -- Minimal config for performance
          on_attach = function(client)
            -- Disable some features for low-end hardware
            client.server_capabilities.semanticTokensProvider = nil
          end,
        })
      end
    end,
  },

  -- Completion (minimal)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        -- Performance optimizations
        performance = {
          debounce = 150,
          throttle = 50,
        },
      })
    end,
  },

  -- Git integration (lightweight)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        -- Disable expensive features
        current_line_blame = false,
        word_diff = false,
      })
    end,
  },

  -- Fuzzy finder (minimal config)
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        -- Minimal config for performance
        winopts = {
          height = 0.4,
          width = 0.8,
        },
      })
    end,
  },

  -- Hook for future -DEV features
  -- This allows dynamic loading of additional plugins
  {
    "folke/lazy.nvim",
    init = function()
      -- Load development plugins if available
      local dev_plugins = vim.fn.stdpath("config") .. "/lua/dev-plugins.lua"
      if vim.fn.filereadable(dev_plugins) == 1 then
        vim.cmd("luafile " .. dev_plugins)
      end
    end,
  },
}

-- Lazy setup
require("lazy").setup(plugins, {
  -- Performance optimizations
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  -- Disable some checks for faster startup
  checker = { enabled = false },
  change_detection = { enabled = false },
})

-- Basic Neovim options (optimized for terminal use)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false  -- Disabled for performance
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Performance settings
vim.opt.updatetime = 300
vim.opt.timeoutlen = 300
vim.opt.redrawtime = 1000

-- File handling
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false  -- Disabled for performance on slow storage

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

-- Key mappings (minimal, BAUX-compatible)
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader mappings
map("n", "<leader>pv", vim.cmd.Ex, opts)  -- File explorer
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", opts)  -- Find files
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", opts)  -- Grep
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", opts)  -- Buffers

-- LSP mappings (when available)
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

-- Window navigation (tmux-compatible)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Insert mode escape
map("i", "jk", "<ESC>", opts)

-- Visual mode indent
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Terminal mode escape
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- File type specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- Hook for post-initialization (future -DEV features)
if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/post-init.lua") == 1 then
  require("post-init")
end

-- Final setup message (silent)
vim.api.nvim_echo({{ "BAUX Neovim loaded", "None" }}, false, {})