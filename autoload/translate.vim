" Author: hotoolong <hotoolong.hogehoge@gmail.com>
" License: MIT

let s:endpoint = get(g:, "translate_endpoint", "https://script.google.com/macros/s/AKfycbw_mRV2WossI7ObN0x3XWasgrnlLl1GppxsQ7EPCZKDj85sMNI/exec")

let s:translate_bufname = "translate://result"
let s:last_popup_window = 0
let s:result = []
let s:vim = {}
let s:nvim = {}

function! s:vim.job_start(cmd, op) abort
  call job_start(a:cmd, a:op)
endfunction

function! s:echoerr(msg) abort
  echohl ErrorMsg
  echo "[translate.nvim]" a:msg
  echohl None
endfunction

" translate
function! translate#translate(bang, start, end, ...) abort
  if !has('nvim')
    call s:echoerr("translate.nvim can be executed by neovim.")
    return
  endif

  if !executable("curl")
    call s:echoerr("please install curl")
    return
  endif

  let ln = "\n"
  if &ff == "dos"
    let ln = "\r\n"
  endif

  let text = s:getline(a:start, a:end, ln, a:000)
  if empty(text)
    call s:echoerr("text is emtpy")
    return
  endif

  let cmd = s:create_cmd(text, a:bang)

  echo "Translating..."
  let s:result = []
  let opt = {
      \ 'on_stdout': function('s:tran_out_cb_nvim'),
      \ 'on_stderr': function('s:tran_out_cb_nvim'),
      \ 'on_exit': function('s:tran_exit_cb_nvim')
    \ }
  call jobstart(cmd, opt)
endfunction

" get text from selected lines or args
function! s:getline(start, end, ln, args) abort
  let text = getline(a:start, a:end)
  if !empty(a:args)
    let text = a:args
  endif

  return join(text, a:ln)
endfunction

" create curl command
function! s:create_cmd(text, bang) abort
  let source = get(g:, "translate_source", "en")
  let target = get(g:, "translate_target", "ja")

  let cmd = ["curl", "-s", "-L", s:endpoint, "-d"]
  if a:bang == '!'
    let body = json_encode({'source': target, 'target': source, 'text': a:text})
    let cmd = cmd + [body]
  else
    lt body = json_encode({'source': source, 'target': target, 'text': a:text})
    let cmd = cmd + [body]
  endif
  return cmd
endfunction

" get command result
function! s:tran_out_cb_nvim(ch, msg, event) abort
  call add(s:result, a:msg)
endfunction

" set command result to translate window buffer
function! s:tran_exit_cb_nvim(job, status, event) abort
  echo ""
  call s:create_window()
endfunction

function! s:filter(id, key) abort
  if a:key ==# 'y'
    call setreg(v:register, s:result)
    call popup_close(a:id)
    return 1
  endif
endfunction

" create translate result window
function! s:create_window() abort
  if empty(s:result)
    call s:echoerr("no translate result")
    return
  endif

  if exists("*popup_atcursor") && get(g:, "translate_popup_window", 1)
    call popup_close(s:last_popup_window)
    " get max width
    let maxwidth = 30
    for str in s:result
      let length = len(str)
      if  length > maxwidth
        let maxwidth = length
      endif
    endfor

    let pos = getpos(".")
    let result_height = len(s:result) + 2 " 2 is border thickness

    let line = "cursor-" . printf("%d", result_height)
    if pos[1] < result_height
      let line = "cursor+1"
    endif

    let s:last_popup_window = popup_atcursor(s:result, {
          \ "pos":"topleft",
          \ "border": [1, 1, 1, 1],
          \ "line": line,
          \ "maxwidth": maxwidth,
          \ 'borderchars': ['-','|','-','|','+','+','+','+'],
          \ "moved": "any",
          \ "filter": function("s:filter"),
          \ })
  else
    let current = win_getid()
    let winsize = get(g:,"translate_winsize", len(s:result) + 2)

    if !bufexists(s:translate_bufname)
      " create new buffer
      execute str2nr(winsize) . "new" s:translate_bufname
      set buftype=nofile
      set ft=translate
      nnoremap <silent> <buffer> q :<C-u>bwipeout!<CR>
    else
      " focus translate window
      let tranw = bufnr(s:translate_bufname)
      let winid = win_findbuf(tranw)
      if empty(winid)
        execute str2nr(winsize) . "new | e" s:translate_bufname
      else
        call win_gotoid(winid[0])
      endif
    endif

    " set tranlsate result
    silent % d _
    call setline(1, join(s:result, ','))
    call win_gotoid(current)
  endif
endfunction
