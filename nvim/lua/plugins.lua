local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'Vimjas/vim-python-pep8-indent'
    use 'fnune/base16-vim'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'neomake/neomake'
    use 'neovim/nvim-lspconfig'
    use 'windwp/nvim-autopairs'
    use 'onsails/lspkind-nvim'

    use 'plasticboy/vim-markdown'
    use 'dhruvasagar/vim-table-mode'

    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'L3MON4D3/LuaSnip'

    use 'chrisbra/csv.vim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        "nvim-neorg/neorg",
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
