-- Editor options.
--
-- Ported verbatim from the main config (~/.config/nvim/lua/config/options.lua),
-- minus the LazyVim-only globals (vim.g.autoformat, vim.g.root_spec) which have
-- no meaning without LazyVim, and with folding switched to native Tree-sitter.
local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true

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
-- opt.listchars:append("space:⋅")
opt.listchars:append("eol:↴")

opt.undofile = true
opt.clipboard = "unnamedplus"

-- Folding via native Tree-sitter (Neovim 0.11+); the main config used the old
-- `nvim_treesitter#foldexpr()` vimscript function.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevelstart = 99

opt.swapfile = false
