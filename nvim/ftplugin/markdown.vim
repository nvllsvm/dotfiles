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
