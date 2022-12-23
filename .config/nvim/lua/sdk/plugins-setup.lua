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

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')
  -- My plugins here
  use('nvim-lua/plenary.nvim')

  use('folke/tokyonight.nvim') -- Colorscheme
  use('folke/which-key.nvim') -- Show Keymappings
  use('declancm/maximize.nvim') -- Focus current window
  use('tpope/vim-surround') -- Change surrounding quotes or brackets
  use('numToStr/Comment.nvim') -- Commenting with gc
  use('nvim-lualine/lualine.nvim') -- Status line

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

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
