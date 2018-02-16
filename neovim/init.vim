if !empty($VIRTUAL_ENV)
    let g:python3_host_prog=system("which -a python3 | grep -v \"^$VIRTUAL_ENV\" | head -n 1 | tr -d '\n'")
endif

set ruler
set tabstop=4
set shiftwidth=4
set expandtab

set mouse=a

set clipboard=unnamedplus

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
Plug 'scrooloose/nerdtree'
Plug 'gregsexton/MatchTag'
Plug 'zchee/deoplete-jedi'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'neomake/neomake'
Plug 'udalov/kotlin-vim'
Plug 'plasticboy/vim-markdown'
Plug 'chriskempson/base16-vim'
Plug 'embear/vim-foldsearch'
call plug#end()

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
autocmd BufWinEnter * normal zR

" show trailing spaces
set list listchars=tab:»·,trail:·

let g:neomake_python_enabled_makers = ['flake8']
" E501 is line length of 80 characters
"let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501'], }

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

autocmd FileType markdown autocmd BufWritePost * call system("pandoc-markdown '" . expand("<afile>") . "'")
autocmd FileType rst autocmd BufWritePost * call system("pandoc-rst '" . expand("<afile>") . "'")

let base16colorspace=256
if !empty(glob("~/.base16_theme"))
    execute "colorscheme " . system("basename $(readlink ~/.base16_theme) .sh")
else
    colorscheme base16-default-dark
endif
