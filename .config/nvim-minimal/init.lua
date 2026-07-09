-- Minimal Neovim config (targets Neovim 0.12+).
--
-- Standalone from the main LazyVim config: it lives in its own directory and
-- runs under NVIM_APPNAME=nvim-minimal (see the `nvim-min` alias in ~/.aliases
-- and this folder's README.md).
--
-- Stack:
--   * vim.pack     - built-in plugin manager (Neovim 0.12)
--   * mini.nvim    - primary plugin set
--   * nord.nvim    - colourscheme
--   * native LSP   - vim.lsp.config / vim.lsp.enable (Neovim 0.11+)
--   * mason        - LSP server installer, bridged by mason-lspconfig
--   * treesitter   - highlighting, folding, text objects
--
-- Leader keys must be set before any plugin maps against them.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.plugins")
require("config.lsp")
require("config.keymaps")
require("config.autocmds")
