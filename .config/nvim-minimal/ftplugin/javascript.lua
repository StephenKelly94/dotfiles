-- Filetype plugin for JavaScript.
--
-- Files under ftplugin/<filetype>.lua are auto-sourced by Neovim every time a
-- buffer's filetype is set (see :h ftplugin). This is the idiomatic home for
-- settings and mappings that should be *buffer-local* — use vim.opt_local /
-- vim.bo for options and `{ buffer = true }` for keymaps, never the globals,
-- so they don't leak into other buffers.

local opt = vim.opt_local

-- The JS/TS ecosystem overwhelmingly uses 2-space indentation.
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true

-- Wrap comments/text at 80 columns.
opt.textwidth = 80

-- Buffer-local mapping under <localleader> (the "\" key). localleader is meant
-- for exactly this: per-filetype actions that only make sense in this buffer.
-- Here: run the current file with node in a terminal split.
vim.keymap.set("n", "<localleader>r", function()
    vim.cmd("botright split | resize 15 | terminal node " .. vim.fn.expand("%"))
end, { buffer = true, desc = "Run file with node" })

-- Undo everything above if the filetype changes, so nothing lingers. Neovim
-- runs this string and then clears it — see :h undo_ftplugin.
vim.b.undo_ftplugin = table.concat({
    "setlocal shiftwidth< tabstop< softtabstop< expandtab< textwidth<",
    "silent! nunmap <buffer> <localleader>r",
}, " | ")
