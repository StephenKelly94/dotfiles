local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
    augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
    return
end

return packer.startup(function(use)
    use('wbthomason/packer.nvim')
    -- My plugins here
    use('nvim-lua/plenary.nvim')

    -- Colorscheme
    use('shaunsingh/nord.nvim')
    use('folke/tokyonight.nvim')

    use('folke/which-key.nvim') -- Show Keymappings
    use('declancm/maximize.nvim') -- Focus current window
    use('tpope/vim-surround') -- Change surrounding quotes or brackets
    use('numToStr/Comment.nvim') -- Commenting with gc
    use('nvim-lualine/lualine.nvim') -- Status line
    use('RRethy/vim-illuminate') -- Highlight similar text
    use('lukas-reineke/indent-blankline.nvim') -- Show indentation guides
    use('mbbill/undotree')
    use('ahmedkhalf/project.nvim')

    --Autocompletion
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-cmdline')
    use('hrsh7th/nvim-cmp')

    -- Snippets
    use('L3MON4D3/LuaSnip')
    use('saadparwaiz1/cmp_luasnip')
    use('rafamadriz/friendly-snippets')

    -- LSP
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("neovim/nvim-lspconfig")
    use('hrsh7th/cmp-nvim-lsp')
    use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion
    use('nvim-treesitter/nvim-treesitter-context')

    -- Bufferline
    use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

    -- Treesitter
    use({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    })

    use("windwp/nvim-autopairs")
    use("windwp/nvim-ts-autotag")

    -- git
    use('tpope/vim-fugitive')
    use('lewis6991/gitsigns.nvim')
    use('f-person/git-blame.nvim')

    use({
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            'nvim-lua/plenary.nvim'
        }
    }) -- Searching

    use{
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons'
        }
    } -- File Explorer

    use {
        'goolord/alpha-nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
