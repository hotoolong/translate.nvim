local M = {}

local floatwindows = {}
local augroup = 'plugin-translate-close'

local function split_lines(text)
  return vim.split(text, '\n', { trimempty = true })
end

function M.calc_config(text)
  local lines = split_lines(text)
  local width = 0

  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strwidth(line))
  end

  return {
    relative = 'cursor',
    width = width,
    height = #lines,
    row = 1,
    col = 1,
    style = 'minimal',
  }
end

function M.close(bufnr)
  local win_id = floatwindows[bufnr]
  if win_id == nil then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    return
  end

  if vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end
  floatwindows[bufnr] = nil
end

function M.open(text)
  if vim.g.translate_copy_result then
    vim.fn.setreg(vim.v.register, text)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, split_lines(text))

  local current = vim.api.nvim_get_current_buf()
  floatwindows[current] = vim.api.nvim_open_win(buf, false, M.calc_config(text))

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter' }, {
    group = vim.api.nvim_create_augroup(augroup, { clear = false }),
    buffer = current,
    callback = function()
      M.close(current)
    end,
  })
end

return M
