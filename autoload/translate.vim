" Author: hotoolong <hotoolong.hogehoge@gmail.com>
" License: MIT

let s:endpoint = get(g:, "translate_endpoint", "https://script.google.com/macros/s/AKfycbzkDzp_dcafykiegGEDpRPDBrsqcgr-tBu-ypahrSqggU8Rsk6G/exec")
let s:floatwindows = {}

function! s:echoerr(errmsg) abort
  echohl ErrorMsg
  echomsg "[translate.nvim]"
  for line in split(a:errmsg, "\n")
    echomsg line
  endfor
  echohl None
endfunction

function! s:on_cursor_moved() abort
  let buf_num = bufnr('%')
  if !has_key(s:floatwindows, buf_num)
    autocmd! plugin-translate-close * <buffer>
    return
  endif
  let win_id = s:floatwindows[buf_num]
  if nvim_win_is_valid(win_id)
    call nvim_win_close(win_id, v:true)
  endif
  unlet! s:floatwindows[buf_num]
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
  let text = s:getline(a:start, a:end, ln, a:000)
  if empty(text)
    call s:echoerr("text is emtpy")
    return
  endif
  echo "Translating..."
  let s:result = []
  call jobstart(s:create_command(text), { 'on_stdout': function('s:callback_result'), 'on_exit': function('s:finish_translate') })
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
  let convert_table = s:is_english(a:text)
    \ ? {'source': 'en', 'target': 'ja', 'text': a:text}
    \ : {'source': 'ja', 'target': 'en', 'text': a:text}
  let command = ["curl", "-d", json_encode(convert_table), "-sL", s:endpoint]
  return command
endfunction

function! s:is_english(text) abort
  if match(a:text, '^[[:alnum:][:space:]_.,()"$''"-<>?!//\\`]\+$') == 0
    return v:true
  else
    return v:false
  endif
endfunction

" get command result
function! s:callback_result(ch, msg, event) abort
  call add(s:result, a:msg)
endfunction

" set command result to translate window buffer
function! s:finish_translate(job, status, event) abort
  call s:create_flaotwindow()
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
  let win_id = nvim_open_win(buf, v:false, l:configs)
  let s:floatwindows[bufnr('%')] = win_id
  augroup plugin-translate-close
    autocmd CursorMoved,CursorMovedI,InsertEnter <buffer> call <SID>on_cursor_moved()
  augroup END
endfunction
