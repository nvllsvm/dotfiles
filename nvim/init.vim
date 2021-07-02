let g:python3_host_prog=glob('~/.config/nvim/python3_env/bin/python')

set ruler
set tabstop=4
set shiftwidth=4
set expandtab

set mouse=a

" line numbers
set number
set relativenumber
nmap <silent> <C-n> :set number!<CR>:set relativenumber!<CR>

" case insensitive search
set ignorecase

filetype plugin indent on

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))

set foldmethod=syntax

set nowrap

set cursorline
nmap <silent> <C-c> :set cursorcolumn!<CR>

set hidden

call plug#begin('~/.config/nvim/plugged')
Plug 'hrsh7th/nvim-compe'
Plug 'neomake/neomake'
Plug 'chriskempson/base16-vim'

Plug 'neovim/nvim-lspconfig'

Plug 'Vimjas/vim-python-pep8-indent'

Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
Plug 'mzlogin/vim-markdown-toc'
Plug 'dhruvasagar/vim-table-mode'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'rust-lang/rust.vim'

Plug 'rbgrouleff/bclose.vim'
call plug#end()

let $FZF_DEFAULT_COMMAND = "fd --type file --ignore-file ~/.config/nvim/fzf_fd_ignore"

" disable preview window
set completeopt-=preview

autocmd StdinReadPre * let s:std_in=1

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR>:NeomakeClean<CR><C-l>

" open all folds automatically
autocmd BufWinEnter * normal! zR

" show trailing spaces and tabs
"autocmd FileType * set list listchars=tab:»·,trail:·

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

" readd support for --path to lmk
"autocmd BufWritePost * call system("lmk --path '" . expand('%:p') . "\' &")
autocmd BufWritePost * call system("lmk")

let base16colorspace=256
if !empty(glob("~/.base16_theme"))
    execute "colorscheme " . system("basename $(readlink ~/.base16_theme) .sh")
else
    colorscheme base16-default-dark
endif

let g:markdown_enable_spell_checking = 0

nnoremap <leader>z :Files<Cr>
nnoremap <leader>r :Rg<Cr>

nnoremap <leader>f :Ex<Cr>

nnoremap <leader>n :bn<Cr>
nnoremap <leader>p :bp<Cr>
nnoremap <leader>D :bd<Cr>
nnoremap <leadr>3 :b#<Cr>
nnoremap <leader>l :buffers<CR>:buffer<Space>

let g:netrw_banner = 0
let g:netrw_dirhistmax = 0
let g:netrw_list_hide = '^.git/$,.pyc$,^../,^./'
let g:netrw_bufsettings="noma nomod nu nobl nowrap ro rnu"

autocmd VimResized * wincmd =

augroup JSON
    function _JSONify()
        set filetype=json
        %!jq -S '.'
        normal zR
    endfunction

    command JSON call _JSONify()

    au BufNewFile,BufRead *.avsc set filetype=json
augroup END

" need to set both + and * else netrw barfs
let g:clipboard = {'copy': {'*': 'cbcopy', '+': 'cbcopy'}, 'paste': {'*': 'cbpaste', '+': 'cbpaste'}}

let g:mkdp_echo_preview_url = 1
let g:netrw_browsex_viewer= "open"

function _IdentifyHighlightingGroup()
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction
command IdentifyHighlightingGroup :call _IdentifyHighlightingGroup()

lua << EOF
vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}
EOF

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "jedi_language_server", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
