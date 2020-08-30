syntax case match

" todo
syn match mkdTodo /TODO:\?/ containedin=htmlH[1-6],mkdNonListItemBlock
hi def link mkdTodo  Todo

" checkbox
syn match mkdCheckbox /\[[ x]\]/ containedin=mkdNonListItemBlock,mkdListItemLine
hi def link mkdCheckbox  Special

" highlight leading #'s in headings 
hi def link mkdHeading Title

syntax case ignore
