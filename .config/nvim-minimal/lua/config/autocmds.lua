-- Autocmds.
--
-- The main config's autocmds.lua had everything commented out; those examples
-- are preserved below as-is. On top of them we enable a couple of universally
-- useful minimal-config defaults.
local augroup = vim.api.nvim_create_augroup("minimal", { clear = true })

-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    desc = "Highlight on yank",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Return to the last cursor position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    desc = "Restore last cursor position",
    callback = function(ev)
        local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(ev.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- ── Ported (commented) examples from the main config ───────────────────────
-- Trim whitespace
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     group = augroup,
--     pattern = { "*" },
--     callback = function()
--         if vim.bo.filetype ~= "markdown" then
--             vim.cmd([[%s/\s\+$//e]])
--         end
--     end,
-- })

-- vim.api.nvim_create_autocmd("ColorScheme", {
--     group = augroup,
--     pattern = "*",
--     callback = function()
--         vim.cmd 'hi Normal guibg=NONE ctermbg=NONE'
--     end,
-- })
