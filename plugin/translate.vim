" Author : hotoolong<hotoolong.hogehoge@gmail.com>
" License: MIT

scriptencoding utf-8

if !has('nvim')
  echohl ErrorMsg
  echo '[transalte.nvim] doesn''t support vim'
  echohl None
  finish
endif

if exists('g:loaded_translate')
  finish
endif

let g:loaded_translate = 1

command! -range -nargs=? Translate call translate#translate(<line1>, <line2>, <f-args>)

nnoremap <silent> <Plug>(Translate) :<C-u>Translate<CR>
vnoremap <silent> <Plug>(VTranslate) :Translate<CR>
