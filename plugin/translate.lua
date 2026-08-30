if vim.fn.has('nvim') == 0 then
  return
end

if vim.g.loaded_translate then
  return
end
vim.g.loaded_translate = 1

vim.api.nvim_create_user_command('Translate', function(opts)
  require('translate').translate(opts.line1, opts.line2, opts.fargs)
end, { range = true, nargs = '?' })

vim.keymap.set('n', '<Plug>(Translate)', '<Cmd>Translate<CR>', { silent = true })
vim.keymap.set('x', '<Plug>(VTranslate)', ':Translate<CR>', { silent = true })
