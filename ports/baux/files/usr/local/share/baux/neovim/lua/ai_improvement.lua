-- AI Improvement Module for Neovim
-- Provides seamless integration with bigrag-debugger.sh for code improvement

local M = {}

-- Main AI improvement function
function M.improve_current_file()
  local file_path = vim.fn.expand('%:p')
  if not file_path or file_path == '' then
    vim.notify('No file to improve', vim.log.levels.WARN)
    return
  end

  -- Run aa command synchronously
  vim.notify('AI processing... (may take 1-2 minutes)', vim.log.levels.INFO)
  local output = vim.fn.system('aa "' .. file_path .. '"')

  if vim.v.shell_error ~= 0 then
    vim.notify('AI command failed: ' .. output, vim.log.levels.ERROR)
    return
  end

  -- Create vertical split with improved content
  vim.cmd('vsplit')
  vim.cmd('enew')

  -- Set buffer name: original-improved.ext
  local filename = vim.fn.fnamemodify(file_path, ':t')
  local name_without_ext = vim.fn.fnamemodify(filename, ':r')
  local ext = vim.fn.fnamemodify(filename, ':e')
  local new_name = name_without_ext .. '-improved.' .. ext
  vim.cmd('file ' .. vim.fn.fnameescape(new_name))

  -- Populate buffer
  local lines = vim.split(output, '\n', { plain = true })
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  -- Set filetype for syntax highlighting
  local ft_map = {
    sh = 'sh',
    bash = 'sh',
    lua = 'lua',
    py = 'python',
    js = 'javascript',
    ts = 'typescript',
    md = 'markdown'
  }
  if ft_map[ext] then
    vim.cmd('set filetype=' .. ft_map[ext])
  end

  -- Enable line numbers and make read-only for safety
  vim.cmd('setlocal number')
  vim.cmd('setlocal relativenumber')
  vim.cmd('setlocal nomodifiable')

  vim.notify('AI improvement complete - :setlocal modifiable to edit, :w to save as ' .. new_name, vim.log.levels.INFO)
end

-- Setup function to register keymaps
function M.setup()
  vim.keymap.set('n', '<leader>aa', M.improve_current_file, {
    desc = 'AI: Improve current file with improved buffer'
  })
end

return M