-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local myGroup = vim.api.nvim_create_augroup("MyGroup", { clear = true })
-- Trim whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
    group = myGroup,
    pattern = { "*" },
    callback = function()
        if vim.bo.filetype ~= "markdown" then
            vim.cmd([[%s/\s\+$//e]])
        end
    end,
})

-- vim.api.nvim_create_autocmd("ColorScheme", {
--     group = myGroup,
--     pattern = "*",
--     callback = function()
--         vim.cmd 'hi Normal guibg=NONE ctermbg=NONE'
--     end,
-- })
