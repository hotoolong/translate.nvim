local root = vim.fn.getcwd()
local deps_dir = root .. '/deps'
local plenary_dir = deps_dir .. '/plenary.nvim'

if vim.fn.isdirectory(plenary_dir) == 0 then
  vim.fn.mkdir(deps_dir, 'p')
  vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/nvim-lua/plenary.nvim',
    plenary_dir,
  })
end

vim.opt.runtimepath:append(root)
vim.opt.runtimepath:append(plenary_dir)
vim.cmd('runtime plugin/plenary.vim')
