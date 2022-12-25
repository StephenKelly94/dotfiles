local ts_setup, treesitter = pcall(require, "nvim-treesitter.configs")
if not ts_setup then
    print("No treesitter installed")
    return
end

treesitter.setup({
    highlight = { enable = true },
    indent = { enable = true },
    autotag = { enable = true },
    ensure_installed = {
        "python",
        "json",
        "javascript",
        "typescript",
        "html",
        "css",
        "lua",
        "vim",
        "gitignore",
        "bash",
        "go",
    },
    auto_install = true
})

