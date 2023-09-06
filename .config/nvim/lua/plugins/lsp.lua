return {
    -- Disable autoformat, was causing issues on large files
    {
        "neovim/nvim-lspconfig",
        opts = {
            autoformat = false,
        },
    },
}
