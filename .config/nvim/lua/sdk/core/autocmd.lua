local myGroup = vim.api.nvim_create_augroup('MyGroup', {clear = true})

-- -- Set transparent background
-- vim.api.nvim_create_autocmd("Colorscheme", {
--     group = myGroup,
--     command = "autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE",
-- })

-- Trim whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
    group = myGroup,
    pattern = { "*" },
    callback = function ()
        if vim.bo.filetype ~= "markdown" then
            vim.cmd([[%s/\s\+$//e]])
        end
    end,
})

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.api.nvim_create_autocmd("TextYankPost", {
    group = myGroup,
    command = "silent! lua vim.highlight.on_yank()",
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost",{
    group = myGroup,
    command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
})
