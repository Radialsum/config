"
" Few additions for C and C++ syntax
"
hi  TabError    guibg=gray25
hi  SpaceError  guibg=gray30

syn keyword cLabel      case default private protected public
syn keyword cTodo       contained TODO FIXME XXX NOTE TODO: FIXME: XXX: NOTE:
syn match   cUserCont   display "^\s*\(default\|public\|protected\|private\)\s*:" contains=cLabel

syn match   cTab        display "\t\+"
syn match   cSpaceError display " \+\t" contains=cTab
syn match   cSpaceError display "\t \+" contains=cTab
syn match   cSpaceError display "\s\+$"
syn match   cSpaceError display "[^\\]\s\+$"ms=s+1
syn match   cBSlashError contained "\\\s\+$"

hi! link cUserLabel         Todo
hi! link cTab               TabError
hi! link cBSlashError       Todo
hi! link cSpaceError        SpaceError
