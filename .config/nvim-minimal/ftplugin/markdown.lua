-- Filetype plugin for Markdown.
--
-- See ftplugin/javascript.lua for the general idea: this file is auto-sourced
-- for every Markdown buffer, and everything here is buffer-local. Markdown is a
-- good showcase because prose wants very different behaviour from code.

local opt = vim.opt_local

-- Soft-wrap prose at word boundaries, keeping indentation on wrapped lines.
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- Spell-check prose.
opt.spell = true
opt.spelllang = "en_us"

-- Conceal markup (**bold**, [links](...)) except on the cursor line.
opt.conceallevel = 2
opt.concealcursor = ""

-- 2-space list/quote indentation reads better than tabs in Markdown.
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true

-- With wrapping on, move by *display* line so j/k feel natural in long
-- paragraphs (but only when no count is given, so 5j still jumps 5 real lines).
local expr = { buffer = true, expr = true }
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", expr)
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", expr)

-- <localleader>t toggles a task-list checkbox on the current line.
vim.keymap.set("n", "<localleader>t", function()
    local line = vim.api.nvim_get_current_line()
    if line:match("%[ %]") then
        line = line:gsub("%[ %]", "[x]", 1)
    elseif line:match("%[[xX]%]") then
        line = line:gsub("%[[xX]%]", "[ ]", 1)
    end
    vim.api.nvim_set_current_line(line)
end, { buffer = true, desc = "Toggle task checkbox" })

-- Revert everything above if the filetype changes (see :h undo_ftplugin).
vim.b.undo_ftplugin = table.concat({
    "setlocal wrap< linebreak< breakindent< spell< spelllang<",
    "setlocal conceallevel< concealcursor< shiftwidth< tabstop< expandtab<",
    "silent! nunmap <buffer> j | silent! xunmap <buffer> j",
    "silent! nunmap <buffer> k | silent! xunmap <buffer> k",
    "silent! nunmap <buffer> <localleader>t",
}, " | ")
