-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- AI Improvement Integration
local ai = require('ai_improvement')
ai.setup()
