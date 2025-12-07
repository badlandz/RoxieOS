-- ~/.config/nvim/lua/plugins/baux-gp.lua
-- RoxieOS baux-gp v3 — FINAL — works 2025-11-22
-- Pure Lua, no lazy.nvim required, keymaps inside module

local M = {}

local log_file = "/tmp/baux-bot.log"

-- === VIM BUFFER BOT OUTPUT (yankable, beautiful, no tmux) ===
local bot_buf = nil
local bot_win = nil
local bot_timer = nil

local function open_bot_buffer()
  -- Reuse existing window/buffer
  if bot_win and vim.api.nvim_win_is_valid(bot_win) and bot_buf and vim.api.nvim_buf_is_valid(bot_buf) then
    vim.api.nvim_set_current_win(bot_win)
    return
  end

  -- Open vertical split on the far right
  vim.cmd("botright vsp")
  bot_win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd L")           -- move to far right
  vim.cmd("vertical resize 60") -- nice wide column

  bot_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bot_buf, "BAUX-BOT")
  vim.api.nvim_win_set_buf(bot_win, bot_buf)

  vim.bo[bot_buf].buftype = "nofile"
  vim.bo[bot_buf].bufhidden = "wipe"
  vim.bo[bot_buf].swapfile = false
  vim.bo[bot_buf].modifiable = false
  vim.bo[bot_buf].filetype = "markdown"

  -- Live tail -f every 1s
  if bot_timer then vim.fn.timer_stop(bot_timer) end
  bot_timer = vim.fn.timer_start(1000, function()
    if not (bot_buf and vim.api.nvim_buf_is_valid(bot_buf)) then return end
    local ok, lines = pcall(vim.fn.readfile, log_file)
    if ok and lines then
      vim.api.nvim_buf_set_option(bot_buf, "modifiable", true)
      vim.api.nvim_buf_set_lines(bot_buf, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(bot_buf, "modifiable", false)
      -- Auto-scroll
      if vim.api.nvim_win_is_valid(bot_win) then
        local line_count = #lines
        if line_count > 0 then
          vim.api.nvim_win_set_cursor(bot_win, { line_count, 0 })
        end
      end
    end
  end, { ["repeat"] = -1 })
end

-- === SEND FUNCTION ===
local function send_to_bot(model)
  return function()
    local start_line, end_line
    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" or mode == "\22" then
      start_line = vim.fn.line("v")
      end_line = vim.fn.line(".")
      if start_line > end_line then start_line, end_line = end_line, start_line end
    else
      start_line = vim.fn.line(".")
      end_line = start_line
    end

    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local question = table.concat(lines, "\n")

    -- Grab all README-GROK.md context
    local context = vim.fn.systemlist([[find /src -name README-GROK.md -exec cat {} \; 2>/dev/null | head -c 16000]])

    local payload = {
      model = model,
      file = vim.fn.expand("%:p"),
      question = question,
      context = table.concat(context, "\n")
    }

    local json = vim.fn.json_encode(payload)
    vim.fn.system("baux-bot '" .. vim.fn.escape(json, "'") .. "' &")

    open_bot_buffer()
    print("Sent to " .. model .. " → BAUX-BOT buffer opened")
  end
end

-- === KEYMAPS (inside the module — correct place) ===
vim.keymap.set("n", "<leader>gg", send_to_bot("grok-4"),            { desc = "[G]rok-4 → baux-bot" })
vim.keymap.set("n", "<leader>go", send_to_bot("deepseek-coder"),    { desc = "[O]llama fast → baux-bot" })
vim.keymap.set("n", "<leader>gO", send_to_bot("deepseek-coder:110b"), { desc = "[O]llama BIG → baux-bot" })
vim.keymap.set("v", "<leader>g",  send_to_bot("grok-4"),            { desc = "Send selection → Grok-4" })

-- Optional: close bot buffer with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    if vim.api.nvim_buf_get_name(0) == "BAUX-BOT" then
      vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = true, silent = true })
    end
  end,
})

return M
