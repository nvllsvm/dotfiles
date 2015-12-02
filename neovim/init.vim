colorscheme wombat256mod
set directory=~/.config/nvim/backup/
set ruler
set history=50
set incsearch
set tabstop=4
set expandtab


set mouse=a

" line numbers
set nu

" case insensitive search
set ic

"if &t_Co > 2 || has ("gui_running")
"	syntax on
"	set hlsearch
"endif

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))
au FileType javascript call JavaScriptFold()

set backupdir=~/.vim/backup

set foldmethod=syntax
set foldnestmax=2

set nowrap

set cursorline

nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>

call plug#begin('~/.config/nvim/plugged')
Plug 'tmhedberg/SimpylFold'
Plug 'Shougo/deoplete.nvim'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree'
call plug#end()

" deoplete
let g:deoplete#enable_at_startup = 1
