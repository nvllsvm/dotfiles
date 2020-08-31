autocmd InsertLeave * :update
autocmd TextChanged * :update

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
