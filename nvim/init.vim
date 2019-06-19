let g:python3_host_prog=glob('~/.config/nvim/plugged/python')

let g:deoplete#sources#jedi#python_path=system("python")
let g:deoplete#sources#jedi#ignore_errors=1
let g:deoplete#sources#jedi#show_docstring=1

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

set hidden

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

call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/deoplete.nvim'
Plug 'gregsexton/MatchTag'
Plug 'deoplete-plugins/deoplete-jedi', { 'do': ':UpdateRemotePlugins' }
Plug 'neomake/neomake'
Plug 'chriskempson/base16-vim'
Plug 'dbeniamine/todo.txt-vim'

Plug 'Vimjas/vim-python-pep8-indent'
Plug 'davidhalter/jedi-vim'

Plug 'udalov/kotlin-vim'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}

Plug 'pedrohdz/vim-yaml-folds'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'dhruvasagar/vim-table-mode'

Plug 'rust-lang/rust.vim'

Plug 'rbgrouleff/bclose.vim'

Plug 'chrisbra/csv.vim'
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

function _JSONify()
    set syntax=json
    %!jq -S '.'
    normal zR
endfunction

command JSON call _JSONify()

function _YAMLify()
    set syntax=yaml
    %!yaml-format
    normal zR
endfunction

command YAML call _YAMLify()

au FileType json set shiftwidth=2
au FileType json set tabstop=2

au BufNewFile,BufRead *.avsc set filetype=json

let g:markdown_enable_spell_checking = 0

nnoremap <leader>z :FZF<Cr>

nnoremap <leader>f :Ex<Cr>

nnoremap <leader>n :bn<Cr>
nnoremap <leader>p :bp<Cr>
nnoremap <leader>D :bd<Cr>
nnoremap <leader>3 :b#<Cr>
nnoremap <leader>l :buffers<CR>:buffer<Space>

let g:netrw_banner = 0
let g:netrw_dirhistmax = 0
let g:netrw_list_hide = '^.git/$,.pyc$,^../,^./'
let g:netrw_bufsettings="noma nomod nu nobl nowrap ro rnu"

autocmd VimResized * wincmd =

augroup MARKDOWN
    autocmd FileType markdown nnoremap <leader>m :MarkdownPreview<Cr>
augroup END

augroup XML
    autocmd!
    autocmd FileType xml let g:xml_syntax_folding=1
    autocmd FileType xml setlocal foldmethod=syntax
    autocmd FileType xml :syntax on
    autocmd FileType xml :%foldopen!
augroup END

augroup PYTHON
    au FileType python set foldmethod=indent
    au FileType python nnoremap <leader>y :0,$!yapf<Cr><C-o>
    let g:jedi#completions_enabled = 0
    let g:jedi#use_splits_not_buffers = "bottom"
    let g:jedi#usages_command = "<leader>N"
augroup END

aug CSV_Editing
    let g:csv_autocmd_arrange = 1
    au InsertLeave *.csv :%ArrangeColumn!
    let b:csv_arrange_align = 'l*'
    aut FileType csv set list& listchars&
aug end
