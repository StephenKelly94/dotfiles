vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "q:", "<nop>")
keymap.set("n", "Q", "<nop>")
-- Better window movement
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- Better window resize
keymap.set("n", "<C-Up>", ":resize +2<CR>")
keymap.set("n", "<C-Down>", ":resize -2<CR>")
keymap.set("n", "<C-Left>", ":vertical resize +2<CR>")
keymap.set("n", "<C-Right>", ":vertical resize -2<CR>")

-- Better buffer movement
keymap.set("n", "<S-h>", ":bprev<CR>")
keymap.set("n", "<S-l>", ":bnext<CR>")

-- Move line
keymap.set("n", "<A-j>", ":m .+1<CR>==")
keymap.set("n", "<A-k>", ":m .-2<CR>==")

-- Indent
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Paste and keep register
keymap.set("v", "<leader>p", '"_dP', {noremap = true})
