let g:python3_host_prog=glob('~/.config/nvim/plugged/python')

let g:deoplete#sources#jedi#python_path=system("python")

if !empty($PYTHONPATH)
    let g:deoplete#sources#jedi#extra_path=[$PYTHONPATH]
endif

set ruler
set tabstop=4
set shiftwidth=4
set expandtab

set mouse=a

" line numbers
set number
set relativenumber

" case insensitive search
set ignorecase

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))

set foldmethod=syntax

set nowrap

set cursorline
nmap <C-c> :set cursorcolumn!<CR>

function StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal! mz
    normal! Hmy
    %s/\s\+$//e
    normal! 'yz<CR>
    normal! `z
  endif
endfunction

function _REPL()
    let repl_file = expand("%:p")
    wincmd p
    set nomodified
    let repl_cmd=g:repl_cmd . " '" . repl_file . "'"
    autocmd TermOpen * setlocal statusline=%{repl_cmd}
    call termopen(repl_cmd)
    normal! G
    wincmd p
endfunction

function _REPLInit(...)
    let g:repl_cmd = a:1
    autocmd BufWritePost * call _REPL()
    set splitright
    vnew
    set nonu
    set nornu
    wincmd p
    call _REPL()
endfunction

command! -nargs=1 REPL call _REPLInit(<args>)

command FixEmpty :set expandtab | :retab | call StripTrailingWhitespace() | :%s/\r//ge

nmap <C-t> :TableFormat<CR>

call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/deoplete.nvim'
Plug 'gregsexton/MatchTag'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'neomake/neomake'
Plug 'plasticboy/vim-markdown'
Plug 'chriskempson/base16-vim'
Plug 'dbeniamine/todo.txt-vim'
Plug 'udalov/kotlin-vim'
Plug 'godlygeek/tabular'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'
Plug 'zah/nim.vim'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'junegunn/fzf'

Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

call plug#end()

let g:jedi#completions_enabled = 0

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#file#enable_buffer_path = 1

set omnifunc=syntaxcomplete#Complete

" disable preview window
set completeopt-=preview

autocmd StdinReadPre * let s:std_in=1

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" open all folds automatically
autocmd BufWinEnter * normal! zR

" show trailing spaces
set list listchars=tab:»·,trail:·

let g:neomake_python_enabled_makers = ['flake8']

let g:neomake_warning_sign = {'text': 'W'}
let g:neomake_error_sign = {'text': 'E'}
let g:neomake_info_sign = {'text': 'I'}
let g:neomake_message_sign = {'text': 'M'}

augroup my_neomake_highlights
    au!
    autocmd ColorScheme *
      \ hi NeomakeError ctermbg=red |
      \ hi NeomakeWarning ctermbg=yellow
augroup END

autocmd! BufWritePost * Neomake
autocmd BufWritePost * call system("lmk --path '" . expand('%:p') . "\' &")

let base16colorspace=256
if !empty(glob("~/.base16_theme"))
    execute "colorscheme " . system("basename $(readlink ~/.base16_theme) .sh")
else
    colorscheme base16-default-dark
endif

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
endfunction

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

command JSON :%!jq -S '.'

au FileType json set tabstop=2
au FileType json set shiftwidth=2

au BufNewFile,BufRead *.avsc set filetype=json

au FileType python set foldmethod=indent
au FileType python nnoremap <leader>y :0,$!yapf<Cr><C-o>

let g:markdown_enable_spell_checking = 0

" Status Line {
        set laststatus=2                             " always show statusbar
        set statusline=
        set statusline+=%-4.3n\                     " buffer number
        set statusline+=%f\                          " filename
        set statusline+=%h%m%r%w                     " status flags
        set statusline+=%=                           " right align remainder
        set statusline+=%-14(%l,%c%V%)               " line, character
        set statusline+=%<%P                         " file position
"}

nnoremap <leader>z :FZF<Cr>

nnoremap <leader>l :ls<Cr>
nnoremap <leader>n :bn<Cr>
nnoremap <leader>p :bp<Cr>
nnoremap <leader>d :bd<Cr>

let g:netrw_dirhistmax = 0

autocmd VimResized * wincmd =
