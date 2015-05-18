" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimcurrent/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! archlinux.vim
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" For more option refer to /usr/share/vim/vimcurrent/vimrc_example.vim or the
" vim manual

set directory=~/.vim/backup//
set ruler
set history=50
set incsearch
set tabstop=4
set nu
set mouse=a

if &t_Co > 2 || has ("gui_running")
	syntax on
	set hlsearch
endif

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))

set backupdir=~/.vim/backup
set t_Co=256
"let g:zenburn_high_Contrast=1
colorscheme ir_black

set foldmethod=syntax
set foldnestmax=2

set nowrap

set guioptions-=m
set guioptions-=T
set guioptions-=r

set cursorline

nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
