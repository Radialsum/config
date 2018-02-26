"
" vimrc --- for GVim 8, perhaps a gvimrc in disguise.
"
" Last change:  2018-02-26
"
" >>  Based on the example for a vimrc file
" >>  by Bram Moolenaar <Bram@vim.org>
"
" It also includes parts taken from or influenced by:
" * Wu Yongwei's _vimrc
" * http://vim.wikia.com/wiki/Vim_Tips_Wiki
" * https://vi.stackexchange.com/ or https://stackoverflow.com/ or ...
"
" WARNING:
"     mostly used on Win32 environment
"     not tested or not known to work on Unix*
"     NOTE: not using mswin.vim -- i.e. avoids CTRL-V, CTRL-C, ... mappings

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set nobackup

" viminfo is written to ram drive --- it will be lost
if empty($RAMDRIVE)
  set viminfo=
  set noswapfile
else
  " if !isdirectory($RAMDRIVE."/home/".$USERNAME."/tmp")
  "   call mkdir($RAMDRIVE."/home/".$USERNAME."/tmp", "p")
  " endif
  " if !isdirectory($RAMDRIVE."/home/".$USERNAME."/vim")
  "   call mkdir($RAMDRIVE."/home/".$USERNAME."/vim", "p")
  " endif
  if isdirectory($RAMDRIVE."/home/".$USERNAME."/vim")
    execute "set viminfo+=n".$RAMDRIVE."/home/".$USERNAME."/vim/_viminfo"
  else
    set viminfo=
  endif
  if isdirectory($RAMDRIVE."/home/".$USERNAME."/tmp")
    execute "set directory=".$RAMDRIVE."/home/".$USERNAME."/tmp"
  else
    " set dir=~/AppData/Local/Temp//,c:/tmp,.
    set directory=
    set noswapfile
  endif
endif

" set guifont=Andale_Mono:h8:cANSI
" set guifont=Consolas:h9:cANSI
" set guifont=DejaVu_Sans_Mono_for_Powerline:h9:cANSI
" set guifont=Droid_Sans_Mono:h8:cANSI
" set guifont=Droid_Sans_Mono_Slashed:h10:cANSI
set guifont=DejaVu_Sans_Mono:h9:cANSI:qDRAFT
set guioptions-=T

" set background=light
set background=dark
colorscheme _desert
set linebreak

" set shell=C:\windows\system32\cmd.exe
set shell=C:\windows\system32\cmd.exe\ /D

" allow backspacing over everything in insert mode
set incsearch           " do incremental searching
set encoding=utf8       " *** WARNING: this can be problematic ***
set history=50          " keep 50 lines of command line history
set showcmd             " display incomplete commands
set ruler               " show the cursor position all the time

set lines=55
set columns=95
set foldcolumn=2
set foldmethod=marker

" no beep or flash is wanted
set vb t_vb=

" When started as "less" and also when started as "view" ("gview" ?)
if (v:progname =~? "less") || (v:progname =~? "view")
  set ro
  set noma
  set nowa
  set nowrite
  source $VIMRUNTIME/macros/less.vim
  syntax on
  nmap <Down> <C-E>
  nmap <Up> <C-Y>

  if v:progname =~? "less"
    set nofoldenable
  endif

  finish
endif

set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=55
  au BufRead,BufNewFile *.txt setlocal formatoptions+=n
  au BufRead,BufNewFile *.txt setlocal textwidth=57 autoindent smartindent

  " autocmd FileType python
  au BufReadPre,BufNewFile *.py let python_highlight_all=1 |
    \ let python_version_2=1

  " autocmd FileType Makefile
  au BufRead,BufNewFile Makefile* setlocal noexpandtab

  au BufNewFile *
    \ setlocal fileformat=unix autoindent smartindent

  " google style => h2,l1,g2,t0,i4,+4,(0,w1,W4
  au BufRead,BufNewFile *.c,*.cpp,*.h,*.cs
    \ setlocal ts=4 sw=4 sts=4 |
    \ nmap <F6> :call Make(0)<cr> |
    \ imap <F6> <esc>:call Make(0)<cr>a |
    \ nmap <F7> :call Make(1)<cr> |
    \ imap <F7> <esc>:call Make(1)<cr>a |
    \ setlocal cinoptions+=:0,l1,b0,g2,h2,(0,t0,i4,+4,w1,W4,N-s
  " ) this comment closes the bracket in cinoptions

  au BufRead *.bat setlocal autoindent smartindent

  au BufNewFile *.bat setlocal fileformat=dos autoindent smartindent

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig let &columns=172 | vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis

map <M-Up> <Up>
map <M-Down> <Down>
map <M-Right> <Right>
map <M-Left> <Left>

imap <M-Up> <Up>
imap <M-Down> <Down>
imap <M-Right> <Right>
imap <M-Left> <Left>

nmap <M-F1> :set modifiable! modifiable?<cr>
nmap <C-F1> :set viminfo=<cr>
nmap <S-F7> :set ic! ic?<cr>
nmap <S-F8> :set wrap! wrap?<cr>
nmap <S-F9> :set number! number?<cr>
nmap <S-Up> <C-Y>
nmap <S-Down> <C-E>
nmap <S-Left> zh
nmap <S-Right> zl
imap <S-Up> <Up>
imap <S-Down> <Down>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
nmap <C-F4> :cclose<cr>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>   :update<cr>
vnoremap <C-S>  <C-C>:update<cr>
inoremap <C-S>  <C-O>:update<cr>

" function FindHere(pat)
"   let s:pat = a:pat " escape(a:pat, '\')
"   let s:cmd = "vimgrep /".s:pat."/j **/*"
"   echo s:cmd
"   exe s:cmd
"   cwindow
" endfunction
" command -nargs=1 VG call FindHere(<f-args>)
" nmap  :let @s='"\\<'.expand("<cword>").'\\>"'<cr>:call FindHere(s)<cr>lh
" vmap  "sy:let @s=string(@s)<cr>:call FindHere(s)<cr>lh
" nmap <S-F3> :GtagsCursor<cr>

" common keyword search tasks
nmap <C-F3> :let @s=expand("<cword>")<cr>:vimgrep /\<s\>/j **/*.cpp **/*.c **/*.h<cr>lh
vmap <C-F3> "sy:vimgrep /s/j **/*.cpp **/*.c **/*.h<cr>lh
nmap <C-F2> :let @s=expand("<cword>")<cr>:vimgrep /\<s\>/j **/*.cpp **/*.c<cr>lh
vmap <C-F2> "sy:vimgrep /s/j **/*.cpp **/*.c<cr>lh
nmap <S-F2> :let @s=expand("<cword>")<cr>:vimgrep /\<s\>/j **/*.h<cr>lh
vmap <S-F2> "sy:vimgrep /s/j **/*.h<cr>lh

" for mark.vim plugin
nmap <F3> \*
nmap <S-F3> \#
nmap <F2> \m
vmap <F2> \m
" nmap <S-F1> \n
nmap <F1> \n:nohlsearch<cr>

let s:toggle_search = 0
function ToggleSearchHl()
  if s:toggle_search == 0
    let s:toggle_search = 1
    hi! Search gui=NONE guifg=gray10 guibg=gold
  else
    let s:toggle_search = 0
    hi! Search gui=reverse guifg=NONE guibg=gray10
  endif
  " echo s:toggle_search
endfunction

nmap <F5> :call ToggleSearchHl()<cr>

let s:cnum = 0
function! ShowNextError(dir)
  try
    if s:cnum == 0
      if a:dir > 0
        cfirst
      else
        clast
      endif
      let s:cnum = 1
    elseif s:cnum == -1
      let s:cnum = 1
      cfirst
      echohl ErrorMsg | echon 'showing first error, if any' | echohl None
      let s:cnum = 1
    else
      if a:dir > 0
        cnext
      else
        cprev
      endif
    endif
  catch /^Vim/
    let s:cnum = -1
    echohl ErrorMsg | echon substitute(v:exception, "^Vim[^:]*:", "", "") | echohl None
  endtry
endfunction

nmap <F4> :call ShowNextError(1)<cr>
nmap <S-F4> :call ShowNextError(-1)<cr>

" function Gnuindent()
"   "exe "%!indent -st -sob -bbb -bap -npsl -npcs -ncs -cdw -nfca -nfc1 -ss -ut -i4 -ts4 -bli0 -l160 -lc160 -c45 -cd45"
"   "exe "%!indent -st -sob -bap -npsl -npcs -ncs -cdw -nfca -ss -nut -i4 -ts4 -bli0 -l120 -lc120 -c45 -cd45"
"   exe "%!indent -st -sob -bap -npsl -npcs -ncs -cdw -nfca -ss -nut -i4 -ts4 -bli0 -l120 -lc120"
" endfunction

function IndentPrep(canjump)
  if (!a:canjump)
    normal! mj
  endif
  silent! %retab
  silent! %s/[ \r\t]\+$//
  silent! %s/(\zs\_s\+//g
  silent! %s/\_s\+\ze)//g
  silent! %s/\n\n\n\+/\r\r/
  silent! %s/{\zs\n\n\+/\r/
  silent! %s/\n\n\+\ze\s*}/\r/
  silent! %s/^}\n\ze\S/&\r/
  silent! %s/\_s*\%$/\r/
  if (!a:canjump)
    normal! `j
  endif
  echo 'prepared for indentation'
endfunction

function IndentPatch(canjump)
  if (!a:canjump)
    normal! mj
  endif
  silent! %s/\n\zs\n\+\ze\s\+\(case\|default\)//
  silent! %s/}\n\zs\n\+\ze\s\+\(break\|continue\);//
  silent! %s/\_s*\%$/\r/
  if (!a:canjump)
    normal! `j
  endif
endfunction

function! ReSpace()
  normal! mi
  silent! %retab
  silent! :%s/[ \r\t]\+$//e
  normal! `i
endfunction

function AStyle1tbs()
  normal! mi
  call IndentPrep(1)
  " exe "%!astyle -A10 -w -Y -j -c -f -p -H -U -k1 -xG -xn -xc -xk -xV -xy -o --mode=c"
  exe "%!astyle -A10 -w -Y -j -c -f -p -H -U -k1 -xG -xk -xV -xy -o -O --mode=c"
  call IndentPatch(1)
  normal! `i
endfunction

function AStyleA4()
  normal! mi
  exe "%!astyle -A4 -w -Y -j -c -f -p -H -U -k1 -xG --mode=c"
  silent! %s/\_s*\%$/\r/
  normal! `i
endfunction

function AStyleA14()
  normal! mi
  exe "%!astyle -A14 -w -Y -j -c -f -p -H -U -k3 -xG --mode=c"
  silent! %s/\_s*\%$/\r/
  normal! `i
endfunction

" TODO - check LLVM for clang-format

function Pylint()
  if expand("%:e") == 'py'
    cexpr system('cmd /c "pylint.bat --output-format=parseable ' . expand('%') . '"')
  else
    echo 'OOps'
  endif
endfunction

function PyPep8()
  if expand("%:e") == 'py'
    cexpr system('cmd /c "pep8.bat ' . expand('%') . '"')
  else
    echo 'OOps'
  endif
endfunction

function PyChecker()
  if expand("%:e") == 'py'
    cexpr system('cmd /c "pychecker.bat ' . expand('%') . '"')
  else
    echo 'OOps'
  endif
endfunction

" Make() is a simple single file compilation support function.
" It depends on cc.bat and ccc.bat; ccc.bat is a sym-link to cc.bat
"
" Make(0) is mapped to <F6> calls ccc.bat to check syntax only
" Make(0) is mapped to <F7> calls cc.bat and can produce executable
" The first argument of cc.bat is a compiler id that is the range
" of the Mark()
" E.g. keystrokes 5<F7> calls LLVM/Clang for compilation
"
" WARNING: since range is used in an odd way and it depends on an
"          external cc.bat extra care should be taken to use this.
"
let s:ccid = 0
function! Make(compile) range
  if (match(expand('%'), '\.\(c\|cpp\|cc\)$\c') > 0)
    let s:cnum = 0
    let l:cc = 'ccc.bat'
    if a:compile > 0
      let l:cc = 'cc.bat'
    endif
    if executable(l:cc)
      let l:oldmp=&makeprg
      set makeprg=cc
      if a:compile > 0
        set makeprg=c
      endif
      let s:ccid = v:count > 0 ? v:count : s:ccid == 0 ? 14 : s:ccid
      let l:cmd = 'make! ' . s:ccid

      if s:ccid == 14 && exists("g:msvc_cxxflags")
        let l:cmd .= ' ' . g:msvc_cxxflags
      elseif exists("g:cxxflags")
        let l:cmd .= ' ' . g:cxxflags
      endif
      if (match(expand('%:r'), '\s') > 0)
        let l:cmd .=  ' "' . expand('%') . '"'
      else
        let l:cmd .=  ' ' . expand('%')
      endif

      lcd %:h
      silent! update
      echon "\r" l:cmd
      silent! exe l:cmd

      let l:m = { 'error':0, 'warning':0, 'note':0 }
      for l in getqflist()
        " if l.valid
          let l:m.error += match(l.text, ' error[ :]\c') >= 0 ? 1 : 0
          let l:m.warning += match(l.text, ' warning[ :]\c') >= 0 ? 1 : 0
          let l:m.note += match(l.text, ' note[ :]\c') >= 0 ? 1 : 0
        " endif
      endfor
      let l:msg = 'make! compiler(' . l:cc . ' ' . s:ccid . ') '
      if l:m.error > 0
        echohl ErrorMsg
        echon "\r" l:msg ': error ' l:m.error '; warning ' l:m.warning
      elseif l:m.warning > 0
        echohl Todo
        echon "\r" l:msg ': warning ' l:m.warning '; note ' l:m.note
      elseif l:m.note > 0
        echohl Search
        echon "\r" l:msg ': error/warning 0' l:m.warning '; note ' l:m.note
      else
        echohl MoreMsg
        echon "\r" l:msg ': done'
      endif
      echohl None
      if l:m.error + l:m.warning + l:m.note > 0
        copen
        wincmd p
      else
        cwindow
      endif
      let &makeprg=l:oldmp
    else
      echohl WarningMsg
      echo 'Error: compiler stub ''' l:cc ''' not found'
      echohl None
    endif
  else
    echohl ErrorMsg
    echo 'Error: ''cc'' can compile or check .c/.cpp files only'
    echohl None
    if bufname("%") == "" 
      wincmd p
    endif
  endif
endfunction

" older version of Mark()
" function! Make() range
"   if (match(expand('%'), "\\c\\.cpp$") > 0) || (match(expand('%'), "\\c\\.c$") > 0)
"     if executable("cc.bat")
"       let l:oldmp=&makeprg
"       set makeprg=cc
"       let l:ccid = v:count
"       if l:ccid > 0
"         let s:ccid = l:ccid
"       elseif s:ccid == 0
"         let s:ccid = 14
"       endif
" 
"       if  s:ccid > 0
"         let s:cmd = "make! " . s:ccid . " " . expand("%")
"       else
"         let s:cmd = "make! d ".expand("%")
"       endif
"       echon "\r" s:cmd
"       silent! update
"       lcd %:h
"       silent! exe s:cmd
"       echohl MoreMsg
"       echon "\r" s:cmd " - done"
"       echohl None
"       cwindow
"       let &makeprg=l:oldmp
"     else
"       echohl WarningMsg
"       echo "Error: compiler stub \"cc.bat\" not found"
"       echohl None
"     endif
"   else
"     echohl ErrorMsg
"     echo "Error: cc can only compile .c/.cpp files"
"     echohl None
"   endif
" endfunction

" changes color scheme; _desert is too dark for editing c-macros
function! ColorSwitch()
  if &background == 'light'
    set background=dark
    colorscheme _desert
  else
    set background=light
    colorscheme default
    hi! Normal guibg=#f5f5f5
  endif
  call InitMarkColor()
endfunction

nmap <C-F5> :call ColorSwitch()<cr>

nmap <F12> :TlistToggle<cr>

" relax ~/vimfiles/after/syntax/c.vim
" .../after/syntax/c.vim highlight some space/indentation errors
function ResetAfterC()
  hi! link cTab               Normal
  hi! link cBSlashError       Normal
  hi! link cSpaceError        Normal
endfunction

nmap <S-F5> :call ResetAfterC()<cr>

" WARNING: below two are unusual and can be surprising
imap <S-CR> o
smap <cr> <esc>o

" set updatetime=2000
" set cursorline

set makeprg=rem
set wildignore=*.o,*.obj,*.a,*.lib,*.pdb,*.dll,*.bak,*.pch
set shellslash
set laststatus=2

" flags for Make()
let g:msvc_cxxflags='-EHa'
let g:cxxflags=''

" for taglist plugin
let Tlist_Show_One_File = 1

" for vim-notes plugin
" let g:notes_suffix = '.txt'

" for calendar plugin
" let g:calendar_mark = 'right'
" let g:calendar_monday = 1
" let g:calendar_weeknm = 5

" for mark.vim plugin --- need to revise the colors
let g:mwHistAdd = ""
function InitMarkColor()
  hi MarkWord1  guibg=#90f9b0 guifg=black
  hi MarkWord2  guibg=#a090f9 guifg=black
  hi MarkWord3  guibg=#f990f0 guifg=black
  hi MarkWord4  guibg=#90e1f9 guifg=black
  hi MarkWord5  guibg=#f99090 guifg=black
  hi MarkWord6  guibg=#f9f090 guifg=black
  hi MarkWord7  guibg=#a0f990 guifg=gold4
  hi MarkWord8  guibg=#90f9e1 guifg=gold4
  hi MarkWord9  guibg=#90aff9 guifg=gold4
  hi MarkWord10 guibg=#d190f9 guifg=gold4
  hi MarkWord11 guibg=#f990c1 guifg=gold4
  hi MarkWord12 guibg=#f9da90 guifg=gold4
  hi MarkWord13 guibg=#b8f990 guifg=gold4
  hi MarkWord14 guibg=#90f9c8 guifg=cyan4
  hi MarkWord15 guibg=#90c8f9 guifg=cyan4
  hi MarkWord16 guibg=#b890f9 guifg=cyan4
  hi MarkWord17 guibg=#f990d9 guifg=cyan4
  hi MarkWord18 guibg=#f9a890 guifg=cyan4
  hi MarkWord19 guibg=#e9f990 guifg=cyan4
  hi MarkWord20 guibg=#90f999 guifg=purple3
  hi MarkWord21 guibg=#90f9f9 guifg=purple3
  hi MarkWord22 guibg=#9099f9 guifg=purple3
  hi MarkWord23 guibg=#e990f9 guifg=purple3
  hi MarkWord24 guibg=#f990a8 guifg=purple3
  hi MarkWord25 guibg=#f9c190 guifg=purple3
  hi MarkWord26 guibg=#d1f990 guifg=purple3
endfunction

