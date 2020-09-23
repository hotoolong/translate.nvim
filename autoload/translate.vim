" Author: hotoolong <hotoolong.hogehoge@gmail.com>
" License: MIT

let s:endpoint = get(g:, "translate_endpoint", "https://script.google.com/macros/s/AKfycbzkDzp_dcafykiegGEDpRPDBrsqcgr-tBu-ypahrSqggU8Rsk6G/exec")
let s:translate_bufname = "translate://result"
let s:last_popup_window = 0

function! s:echoerr(msg) abort
  echohl ErrorMsg
  echo "[translate.nvim]" a:msg
  echohl None
endfunction

" translate
function! translate#translate(start, end, ...) abort
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

  let cmd = s:create_command(text)

  echo "Translating..."
  let s:result = []
  call jobstart(cmd, { 'on_stdout': function('s:callback_result'), 'on_exit': function('s:finish_translate') })
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
function! s:create_command(text) abort
  let source = get(g:, "translate_source", "en")
  let target = get(g:, "translate_target", "ja")
  let params = json_encode({'source': source, 'target': target, 'text': a:text})
  let command = ["curl", "-d", params, "-sL", s:endpoint]
  return command
endfunction

" get command result
function! s:callback_result(ch, msg, event) abort
  call add(s:result, a:msg)
endfunction

" set command result to translate window buffer
function! s:finish_translate(job, status, event) abort
  call s:create_flaotwindow()
endfunction

function! s:filter(id, key) abort
  if a:key ==# 'y'
    call setreg(v:register, s:result)
    call popup_close(a:id)
    return 1
  endif
endfunction

" create translate result window
function! s:create_flaotwindow() abort
  if empty(s:result)
    call s:echoerr("no translate result")
    return
  endif

  let results = []
  let maxwidth = 0
  for list in s:result
    if len(list) > 0
      let str = list[0]
      if len(str) < 1
        continue
      endif

      let data = json_decode(l:str)
      let lines = split(l:data["result"], "\n")
      for line in l:lines
        let length = strlen(line)
        if length > maxwidth
          let maxwidth = length
        endif
        call add(l:results, l:line)
      endfor
    endif
  endfor

  let configs = {
    \ 'relative': 'cursor',
    \ 'width': maxwidth,
    \ 'height': len(l:results),
    \ 'row': 1,
    \ 'col': 1,
    \ 'style': 'minimal',
    \ }
  let buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(buf, 0, -1, v:true, l:results)
  let winid = nvim_open_win(buf, v:false, l:configs)
endfunction
