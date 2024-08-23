-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
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
keymap.set("v", "<leader>p", '"_dp', { noremap = true })

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

keymap.set("n", "<leader>gf", function()
    vim.cmd([[!git log -1 --format="medium" -- %]])
end, { desc = "Git last commit info" })

-- vim.keymap.set("n", "J", "mzJ`z")
