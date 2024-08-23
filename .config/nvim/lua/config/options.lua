-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
-- nosplit will remove the window
opt.inccommand = 'split'

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.colorcolumn = "80"

-- Backspace
opt.backspace = "indent,eol,start"

-- Splitting
opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- opt.listchars:append("space:⋅")
-- opt.listchars:append("eol:↴")

opt.undofile = true
opt.clipboard = "unnamedplus"

opt.foldmethod = "indent"
opt.foldlevelstart = 99
