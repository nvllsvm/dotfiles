autocmd InsertLeave,TextChanged,FocusLost * :update
autocmd FocusGained * :e

" talbe_mode_always_active breaks highlighting
TableModeEnable

let g:vim_markdown_auto_insert_bullets=1
let g:vim_markdown_new_list_item_indent=0
setlocal formatlistpat=^\\s*\\d\\+[.\)]\\s\\+\\\|^\\s*[*+~-]\\s\\+\\\|^\\(\\\|[*#]\\)\\[^[^\\]]\\+\\]:\\s 
setlocal comments=n:>
setlocal formatoptions+=cn
nnoremap <leader>m :TableModeRealign<Cr>:TableSort<Cr>
set linebreak
set list& listchars&
highlight Title cterm=bold

" conceal links
set conceallevel=2

let g:vim_markdown_conceal_code_blocks = 0

let g:vim_markdown_folding_style_pythonic = 1


" r Automatically insert the current comment leader after hitting
"   <Enter> in Insert mode.
" o Automatically insert the current comment leader after hitting 'o' or
"   'O' in Normal mode.
set formatoptions+=ro
