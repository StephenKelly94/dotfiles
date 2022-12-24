local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
    print("No lspconfig installed")
    return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
    print("No cmp_nvim_lsp installed")
    return
end

