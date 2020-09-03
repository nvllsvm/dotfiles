syntax case match

" due
syn match mkdDue /due:\d\d\d\d-\d\d-\d\d/ containedin=htmlH[1-6],mkdNonListItemBlock,mkdListItemLine
hi def link mkdDue Todo

" todo
syn match mkdTodo /TODO:\?/ containedin=htmlH[1-6],mkdNonListItemBlock,mkdListItemLine
hi def link mkdTodo Todo
hi Todo cterm=bold

" checkbox
syn match mkdCheckboxUnchecked /\[ \]/ containedin=mkdNonListItemBlock,mkdListItemLine
syn match mkdCheckboxChecked /\[x\].*/ containedin=mkdNonListItemBlock,mkdListItemLine
hi def mkdCheckboxUnchecked ctermfg=8
hi def mkdCheckboxChecked ctermfg=8

" bold and italics
hi mkdItalic        term=italic cterm=italic gui=italic
hi htmlBold         term=bold cterm=bold gui=bold
hi mkdBoldItalic    term=bold,italic cterm=bold,italic gui=bold,italic

" heading level colors
hi mkdHeading ctermfg=8

" purple
hi htmlH1 cterm=bold ctermfg=5
" blue
hi htmlH2 cterm=bold ctermfg=4
" green
hi htmlH3 cterm=bold ctermfg=2
" red
hi htmlH4 cterm=bold ctermfg=1
" cyan
hi htmlH5 cterm=bold ctermfg=6
" orange
hi htmlH6 cterm=bold ctermfg=17

syntax case ignore
