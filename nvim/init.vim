if !empty($VIRTUAL_ENV)
    let g:python3_host_prog=system("which -a python3 | grep -v \"^$VIRTUAL_ENV\" | head -n 1 | tr -d '\n'")
else
    let g:deoplete#sources#jedi#python_path=system("which python3 | tr -d '\n'")
endif

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
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction

command FixEmpty :set expandtab | :retab | call StripTrailingWhitespace() | :%s/\r//ge

nmap <C-n> :NERDTreeToggle<CR>
nmap <C-t> :TableFormat<CR>

let NERDTreeQuitOnOpen=1
let NERDTreeIgnore=['^__pycache__$[[dir]]', '\.pyc$']

call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/deoplete.nvim'
Plug 'scrooloose/nerdtree'
Plug 'gregsexton/MatchTag'
Plug 'zchee/deoplete-jedi'
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

command JSON :%!python3 -m json.tool

" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

au BufNewFile,BufRead *.avsc set filetype=json

au FileType python set foldmethod=indent

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

" workaround for https://github.com/neovim/neovim/issues/7861
autocmd VimResized * redraw!
