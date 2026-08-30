local M = {}

function M.check()
  vim.health.start('translate.nvim')

  if vim.system == nil then
    vim.health.error('vim.system() is not available', { 'Please install Neovim 0.10.0 or later' })
  else
    vim.health.ok('vim.system() is available for asynchronous execution')
  end

  if vim.fn.executable('curl') == 1 then
    vim.health.ok('curl is executable')
  else
    vim.health.error('curl is not executable', { 'Please install curl' })
  end
end

return M
