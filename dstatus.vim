"
" dstatus - dynamic statusline
"
" Last change:  2018-03-20
"

let s:status = 1      " 3: fancier, 2: fancy, 1: minimal, 0: normal
let s:show_mode = 1   " show mode
let s:show_flag = 1   " show read-only/modifiable/modified -> rm-
let s:show_ftyp = 1   " show file type
let s:show_ffen = 1   " show file-format and file-encoding

let s:timer_id = 0    " used for auto-commands to modify status-line

nmap <S-F1> :call SetStatusLine()<cr>

function! StatusMode()
  let l:mode = mode()
  if l:mode == 'n'
    hi User1 guibg=#c2bfa5 guifg=gray20
    return 'N '
  elseif l:mode == 'i'
    hi User1 guibg=#3333cc guifg=#ffffff
    return ' I '
  elseif l:mode == 'R' ||  l:mode == 'Rv'
    hi User1 guibg=#993399 guifg=#ffffff
    return ' R '
  elseif l:mode == 'v' || l:mode == 'V' || l:mode == ''
    hi User1 guibg=#006600 guifg=#ffffff
    return ' V '
  elseif l:mode == 's' || l:mode == 'S' || l:mode == ''
    hi User1 guibg=#cc3333 guifg=#ffffff
    return ' S '
  elseif l:mode == 'no'
    hi User1 guibg=#cc0000 guifg=#ffffff
    return ' : '
  elseif l:mode == '!'
    hi User1 guibg=#cc0000 guifg=#000000
    return ' ! '
  else
    " c	Command-line
    " cv	Vim Ex mode |gQ|
    " ce	Normal Ex mode |Q|
    " r	Hit-enter prompt
    " rm	The -- more -- prompt
    " r?	A |:confirm| query of some sort
    hi User1 guibg=gold    guifg=#000000
    return ' > '
  endif
endfunction

function! FileFormat()
  if &ff !=? 'unix'
    return ' '.&ff.' '
  endif
  return ''
endfunction

function! RedrawStatus()
  redrawstatus
  return ''
endfunction

function! FileEncoding()
  let l:enc = (empty(&fileencoding)?&encoding:&fileencoding)
  if l:enc !=? 'utf-8'
    return ' '.l:enc.' '
  endif
  return ''
endfunction


function! SetStatusLine()
  set statusline=

  let s:status = (s:status <= 0) ? 3 : s:status - 1

  if s:status >= 3
    let s:show_mode = 1
    let s:show_flag = 1
    let s:show_ftyp = 1
    let s:show_ffen = 1
    " echo 'fancier statusline'
  elseif s:status == 2
    let s:show_mode = 0
    let s:show_flag = 1
    let s:show_ftyp = 0
    let s:show_ffen = 1
    " echo 'fancy statusline'
  elseif s:status == 1
    let s:show_mode = 0
    let s:show_flag = 0
    let s:show_ftyp = 0
    let s:show_ffen = 0
    " echo 'minimal statusline'
  else " s:status == 0
    let s:show_mode = 0
    let s:show_flag = 0
    let s:show_ftyp = 0
    let s:show_ffen = 0
    " echo 'resetting statusline ...'
    return 0
  endif

  if s:show_mode
    set statusline+=%1*%4{StatusMode()}   " mode
  endif

  set statusline+=%h                      " help buffer
  set statusline+=%#StatusLine#           " colour
  set statusline+=%<                      " cut at start
  set statusline+=\ %f\                   " file name

  if s:show_flag
    set statusline+=%2*                   " colour
    set statusline+=%{&readonly?'r':''}   " readonly flag
    set statusline+=%3*                   " colour
    set statusline+=%{&modifiable?'':'m'} " modifiable flag
    set statusline+=%2*                   " colour
    set statusline+=%{&modified?'+':''}
    set statusline+=%0*                   " colour
  else
    set statusline+=%0*                   " colour
    set statusline+=%{&modified?'+':''}
  endif

  set statusline+=%=                      " right align

  if s:show_ffen
    set statusline+=%#Todo#               " colour
    set statusline+=%{FileFormat()}       " fileformat
    set statusline+=%#Normal#             " colour
    set statusline+=%{FileEncoding()}     " fileencoding
  endif

  set statusline+=%0*                     " colour

  if s:show_ftyp
    set statusline+=%y                    " file type
  endif

  set statusline+=\ %-14(%l,%c\%V%)       " line + column
  set statusline+=\ %P                    " percentage

  if s:status >= 2
    set statusline+=%{RedrawStatus()}     " force redraw-status
  endif

  " redrawstatus!
endfunction

function! SetNormalStatusLine(...)
  let s:status = 2
  call SetStatusLine()
endfunction

function! SetFancyStatusLine()
  let s:status = 3
  call SetStatusLine()
  if s:timer_id > 0
    call timer_stop(s:timer_id)
  endif
  let s:timer_id = timer_start(10000, 'SetNormalStatusLine')
endfunction

hi User1 guibg=#00cc00 guifg=#000000
hi User2 guibg=#ff6633 guifg=#ffffff
hi User3 guibg=#ff6633 guifg=#ffffff gui=strikethrough

augroup statusEx
au!
autocmd BufReadPost,BufWritePost * call SetFancyStatusLine()

augroup END

