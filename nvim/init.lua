local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'hrsh7th/nvim-compe'
    use 'neomake/neomake'
    use 'fnune/base16-vim'
    use 'neovim/nvim-lspconfig'
    use 'Vimjas/vim-python-pep8-indent'

    use 'plasticboy/vim-markdown'
    use 'dhruvasagar/vim-table-mode'

    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    use 'chrisbra/csv.vim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        "nvim-neorg/neorg",
        ft = "norg",
        after = "nvim-treesitter",
        config = function()
            require('neorg').setup {
		        ["core.defaults"] = {}
            }
        end,
        requires = "nvim-lua/plenary.nvim"
    }
    if packer_bootstrap then
        require('packer').sync()
    end
end)

vim.o.ruler = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.hidden = true

vim.o.foldmethod = "syntax"

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

" disable preview window
set completeopt-=preview

autocmd StdinReadPre * let s:std_in=1

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

]])

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
