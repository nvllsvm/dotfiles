require('plugins')
require('config')

vim.o.ruler = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.hidden = true

vim.o.foldmethod = "syntax"
vim.o.foldenable = false

-- case insensitive search
vim.o.ignorecase = true

vim.g.tex_flavor = "latex"

-- line numbers
vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.api.nvim_set_keymap('n', '<C-n>', ':set number!<CR>:set relativenumber!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-c>', ':set cursorcolumn!<CR>', { noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>z', ':Files<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':Rg<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>f', ':Ex<CR>', { noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>n', ':bn!<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>p', ':bp!<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>D', ':bd<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>3', ':b#<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>l', ':buffers<CR>:buffer<Space>', { noremap = true})

-- <Ctrl-l> redraws the screen and removes any search highlighting.
vim.api.nvim_set_keymap('n', '<C-l>', ':nohl<CR>:NeomakeClean<CR><C-l>', { noremap = true, silent = true})

vim.cmd([[

filetype plugin indent on

let $FZF_DEFAULT_COMMAND = "fd --type file --ignore-file ~/.config/nvim/fzf_fd_ignore"

autocmd StdinReadPre * let s:std_in=1

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

autocmd BufWritePost * call system("lmk")

let base16colorspace=256
if !empty(glob("~/.base16_theme"))
    execute "colorscheme " . system("basename $(readlink ~/.base16_theme) .sh")
else
    colorscheme base16-default-dark
endif

let g:markdown_enable_spell_checking = 0

autocmd VimResized * wincmd =

" need to set both + and * else netrw barfs
let g:clipboard = {'copy': {'*': 'cbcopy', '+': 'cbcopy'}, 'paste': {'*': 'cbpaste', '+': 'cbpaste'}}

let g:mkdp_echo_preview_url = 1
]])

