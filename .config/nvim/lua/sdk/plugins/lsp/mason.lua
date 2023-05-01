local mason_status, mason = pcall(require, "mason")
if not mason_status then
    print("No mason installed")
    return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
    print("No mason_lspconfig installed")
    return
end

mason.setup({
    ui = {
        border = "single"
    }
})
mason_lspconfig.setup({
    ensure_installed = {
        "pyright",
        "jsonls",
        "tsserver",
        "html",
        "cssls",
        "lua_ls",
        "bashls",
        "gopls",
    }
})
