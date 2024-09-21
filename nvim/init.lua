require("config.buffers")
require("config.lazy")
require("config.cmp")
require("config.lsp")

vim.o.ruler = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.hidden = true

vim.o.foldmethod = "syntax"
vim.o.foldenable = false

-- true breaks base16
vim.o.termguicolors = false

-- case insensitive search
vim.o.ignorecase = true

vim.g.tex_flavor = "latex"

-- line numbers
vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a"

vim.api.nvim_set_keymap("n", "<C-n>", ":set number!<CR>:set relativenumber!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", ":set cursorcolumn!<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>z", ":Files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>x", ":Notes<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>r", ":Rg<CR>", { noremap = true, silent = true })

-- <Ctrl-l> redraws the screen and removes any search highlighting.
vim.api.nvim_set_keymap("n", "<C-l>", ":nohl<CR>:NeomakeClean<CR><C-l>", { noremap = true, silent = true })

vim.cmd([[

" relative percentage to screen
let g:lf_width = 1.0
let g:lf_height = 1.0

filetype plugin indent on

let $FZF_DEFAULT_COMMAND = "fd --type file --ignore-file ~/.config/nvim/fzf_fd_ignore"
let g:fzf_preview_window = ['right,50%,<70(hidden,right,50%)', 'ctrl-/']

autocmd StdinReadPre * let s:std_in=1

autocmd BufWritePost * call system("lmk")

if !empty(glob("~/.base16_theme"))
    let base16colorspace=256
    execute "colorscheme " . system("basename $(readlink ~/.base16_theme) .sh")
endif

let g:markdown_enable_spell_checking = 0

autocmd VimResized * wincmd =

" need to set both + and * else netrw barfs
let g:clipboard = {'copy': {'*': 'cbcopy', '+': 'cbcopy'}, 'paste': {'*': 'cbpaste', '+': 'cbpaste'}}
]])
