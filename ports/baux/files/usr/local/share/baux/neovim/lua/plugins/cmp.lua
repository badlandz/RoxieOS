return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
      ["<Tab>"] = require("cmp").mapping.complete(), -- Remap completion to Tab
      ["<C-Space>"] = nil, -- Disable original binding
    })
  end,
}
