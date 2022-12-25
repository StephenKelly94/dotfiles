local clearGroup = vim.api.nvim_create_augroup('bufcheck', {clear = true})

-- Trim whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = clearGroup,
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.api.nvim_create_autocmd("TextYankPost", {
    group = clearGroup,
    command = "silent! lua vim.highlight.on_yank()",
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost",{
    group = clearGroup,
    command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
})
