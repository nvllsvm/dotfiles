if !empty($SYSTEM_PYTHON3_BIN)
    let g:python3_host_prog=$SYSTEM_PYTHON3_BIN
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

function StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction

nmap <F8> :TagbarToggle<CR>
nmap <C-n> :NERDTreeToggle<CR>
map <F12> :silent! exec "!ctags -R 2> /dev/null"<CR>:echo<CR>

let NERDTreeQuitOnOpen=1
let NERDTreeIgnore=['^__pycache__$[[dir]]', '\.pyc$']

call plug#begin('~/.config/nvim/plugged')
Plug 'tmhedberg/SimpylFold'
Plug 'Shougo/deoplete.nvim'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree'
Plug 'jmcantrell/vim-virtualenv'
Plug 'gregsexton/MatchTag'
Plug 'majutsushi/tagbar'
Plug 'pangloss/vim-javascript'
Plug 'freitass/todo.txt-vim'
Plug 'zchee/deoplete-jedi'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'neomake/neomake'
Plug 'udalov/kotlin-vim'
Plug 'rust-lang/rust.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'chriskempson/base16-vim'
call plug#end()

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#auto_completion_start_length = 2
let g:deoplete#sources = {}
let g:deoplete#sources._ = []
let g:deoplete#file#enable_buffer_path = 1

set omnifunc=syntaxcomplete#Complete


autocmd StdinReadPre * let s:std_in=1

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" open all folds automatically
autocmd BufWinEnter * normal zR

" show trailing spaces
set list listchars=tab:»·,trail:·

let g:neomake_python_enabled_makers = ['flake8']
" E501 is line length of 80 characters
"let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501'], }

autocmd! BufWritePost * Neomake

autocmd FileType markdown autocmd BufWritePost * call system("pandoc-markdown " . expand("<afile>"))

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
