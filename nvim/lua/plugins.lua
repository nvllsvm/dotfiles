local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
end

require("packer").startup({
    function(use)
        use("wbthomason/packer.nvim")

        use("Vimjas/vim-python-pep8-indent")
        use("base16-project/base16-vim")
        use("hrsh7th/cmp-buffer")
        use("hrsh7th/cmp-cmdline")
        use("hrsh7th/cmp-nvim-lsp")
        use("hrsh7th/cmp-path")
        use("hrsh7th/nvim-cmp")
        use("neomake/neomake")
        use("neovim/nvim-lspconfig")

        use("voldikss/vim-floaterm")
        use("ptzz/lf.vim")

        use("plasticboy/vim-markdown")
        use("dhruvasagar/vim-table-mode")

        use("junegunn/fzf")
        use("junegunn/fzf.vim")
        use("L3MON4D3/LuaSnip")

        use("ledger/vim-ledger")

        use({
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "lua", "rust" },
                    highlight = {
                        enable = true,
                        disable = { 
                            -- broken in Arch neovim-0.9.5-4
                            -- last working in neovim-0.9.5-2
                            'markdown',
                        },
                    },
                })
            end,
        })
        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = { autoremove = true },
})

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
