" Author: hotoolong <hotoolong.hogehoge@gmail.com>
" License: MIT

function! s:check_job() abort
    if !has('nvim') && !has('job')
        call health#report_error('Not supported since +job feature is not enabled')
    else
        call health#report_ok('+job is available to execute Git command')
    endif
endfunction

function! s:check_floating_window() abort
  if !has('nvim')
    return
  endif

  if !exists('*nvim_win_set_config')
    call health#report_warn(
      \ 'Neovim 0.3.0 or earlier does not support floating window feature. Preview window is used instead',
      \ 'Please install Neovim 0.4.0 or later')
    return
  endif
  call health#report_ok('Floating window is available for popup window')
endfunction
