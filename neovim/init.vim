if !empty($ORIG_PYTHON2_BIN)
    let g:python_host_prog=$ORIG_PYTHON2_BIN
endif

if !empty($ORIG_PYTHON3_BIN)
    let g:python3_host_prog=$ORIG_PYTHON3_BIN
endif

colorscheme wombat256mod
set ruler
set tabstop=4
set shiftwidth=4
set expandtab

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
Plug 'w0rp/ale'
call plug#end()

" deoplete
let g:deoplete#enable_at_startup = 1

autocmd StdinReadPre * let s:std_in=1

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" open all folds automatically
autocmd BufWinEnter * normal zR

" show trailing spaces
set list listchars=tab:»·,trail:·
