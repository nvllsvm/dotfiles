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

" case insensitive search
set ignorecase

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))
au FileType javascript call JavaScriptFold()

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

call plug#begin('~/.config/nvim/plugged')
Plug 'tmhedberg/SimpylFold'
Plug 'Shougo/deoplete.nvim'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree'
Plug 'jmcantrell/vim-virtualenv'
Plug 'gregsexton/MatchTag'
call plug#end()

" deoplete
let g:deoplete#enable_at_startup = 1
