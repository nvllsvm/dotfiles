syntax case match

" todo
syn match mkdTodo /TODO:\?/ containedin=htmlH[1-6],mkdNonListItemBlock,mkdListItemLine
hi def link mkdTodo  Todo

" checkbox
syn match mkdCheckbox /\[[ x]\]/ containedin=mkdNonListItemBlock,mkdListItemLine
hi def link mkdCheckbox  Special

" highlight leading #'s in headings 
hi def link mkdHeading Title


" bold and italics
hi mkdItalic        term=italic cterm=italic gui=italic
hi htmlBold         term=bold cterm=bold gui=bold
hi mkdBoldItalic    term=bold,italic cterm=bold,italic gui=bold,italic

syntax case ignore
