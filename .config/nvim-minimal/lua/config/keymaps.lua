-- Keymaps.
--
-- LSP keymaps are buffer-local and live in config/lsp.lua. The picker/explorer/
-- git mappings below reference mini.* globals, which are only defined once their
-- deferred setup() has run — that's fine, the globals are resolved when the key
-- is pressed, not when it's mapped.
local map = vim.keymap.set

-- ── Ported from the main config ────────────────────────────────────────────
-- Paste over a visual selection without clobbering the unnamed register.
map("x", "<leader>p", '"_dP', { desc = "Paste (keep register)" })
-- Keep the cursor in place when joining lines.
map("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })

-- ── Find (mini.pick / mini.extra) ──────────────────────────────────────────
map("n", "<leader>ff", function()
    MiniPick.builtin.files()
end, { desc = "Find files" })
map("n", "<leader>fg", function()
    MiniPick.builtin.grep_live()
end, { desc = "Grep (live)" })
map("n", "<leader>fb", function()
    MiniPick.builtin.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fh", function()
    MiniPick.builtin.help()
end, { desc = "Help tags" })
map("n", "<leader>fr", function()
    MiniExtra.pickers.oldfiles()
end, { desc = "Recent files" })
map("n", "<leader>fd", function()
    MiniExtra.pickers.diagnostic()
end, { desc = "Diagnostics" })
map("n", "<leader>fk", function()
    MiniExtra.pickers.keymaps()
end, { desc = "Keymaps" })

-- ── File explorer (mini.files) ─────────────────────────────────────────────
map("n", "<leader>e", function()
    -- Open focused on the current file, falling back to the cwd.
    local path = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(path ~= "" and path or nil)
end, { desc = "Explorer (file directory)" })
map("n", "<leader>E", function()
    MiniFiles.open()
end, { desc = "Explorer (cwd)" })

-- ── Git (mini.git / mini.diff) ─────────────────────────────────────────────
-- <leader>ub preserves the "toggle git blame" binding from the main config.
map("n", "<leader>ub", function()
    vim.cmd("Git blame -- " .. vim.fn.expand("%:p"))
end, { desc = "Git blame (current file)" })
map("n", "<leader>gb", function()
    vim.cmd("Git blame -- " .. vim.fn.expand("%:p"))
end, { desc = "Git blame (current file)" })
map("n", "<leader>gd", function()
    MiniDiff.toggle_overlay()
end, { desc = "Toggle diff overlay" })
map("n", "<leader>gs", function()
    MiniGit.show_at_cursor()
end, { desc = "Git info at cursor" })

-- ── UI toggles ─────────────────────────────────────────────────────────────
-- <leader>uu preserves the "undotree toggle" binding from the main config.
-- :Undotree is Neovim's built-in plugin (packadd'd in config/plugins.lua) and
-- toggles the window itself.
map("n", "<leader>uu", "<cmd>Undotree<cr>", { desc = "Undotree toggle" })
