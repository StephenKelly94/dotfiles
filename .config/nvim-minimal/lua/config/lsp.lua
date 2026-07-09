-- Language servers, the Neovim-0.11-native way.
--
-- Three pieces, three distinct jobs:
--   * mason.nvim      installs the server *binaries* (the executables).
--   * nvim-lspconfig  ships the per-server *configs* (cmd, filetypes, root
--                     markers, default settings) under its `lsp/` directory.
--   * vim.lsp.enable  actually turns a server on. It only starts once its
--                     config resolves *and* a matching filetype is opened.
--
-- The main config used mason-lspconfig, which bundles two conveniences:
-- auto-installing a list of servers and auto-calling vim.lsp.enable() for each.
-- We've dropped it to keep the moving parts explicit and visible — below we
-- install missing binaries through Mason's own registry API, then enable the
-- servers by name ourselves. Note that Mason package names differ from
-- lspconfig names (e.g. `lua-language-server` vs `lua_ls`); translating between
-- them is exactly the job mason-lspconfig used to do behind the scenes.

require("mason").setup()

-- Servers we want, keyed by Mason package name -> lspconfig config name.
local servers = {
    ["lua-language-server"] = "lua_ls",
    ["typescript-language-server"] = "ts_ls",
    ["json-lsp"] = "jsonls",
    ["yaml-language-server"] = "yamlls",
    ["bash-language-server"] = "bashls",
}

-- Install any missing binaries. Async so the editor isn't frozen on first run;
-- servers become available after the install finishes (reopen the file or
-- :restart). This is the `ensure_installed` behaviour, done by hand.
local registry = require("mason-registry")
registry.refresh(function()
    for mason_name in pairs(servers) do
        if not registry.is_installed(mason_name) then
            local ok, pkg = pcall(registry.get_package, mason_name)
            if ok then
                pkg:install()
            end
        end
    end
end)

-- ── Per-server overrides ───────────────────────────────────────────────────
-- These layer on top of nvim-lspconfig's defaults. Teach lua_ls about the
-- Neovim runtime and the globals used in this config so editing it doesn't
-- produce a wall of "undefined global" warnings.
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            diagnostics = {
                globals = {
                    "vim",
                    "MiniIcons",
                    "MiniPick",
                    "MiniExtra",
                    "MiniFiles",
                    "MiniDiff",
                    "MiniGit",
                    "MiniNotify",
                },
            },
        },
    },
})

-- Enable the servers. Config resolution (defaults + our overrides above) and
-- the actual server launch happen lazily, when a matching buffer opens.
local names = {}
for _, lsp_name in pairs(servers) do
    names[#names + 1] = lsp_name
end
vim.lsp.enable(names)

-- ── Diagnostics UI ─────────────────────────────────────────────────────────
vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    underline = true,
    float = { border = "rounded", source = true },
})

-- ── Buffer-local LSP keymaps ───────────────────────────────────────────────
-- Neovim 0.11 already ships sensible defaults: grn (rename), gra (code action),
-- grr (references), gri (implementation), grt (type definition), gO (document
-- symbols), K (hover), and <C-s> (signature help, insert mode). The mappings
-- below add the few conventional extras that aren't covered by defaults.
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP buffer-local keymaps",
    callback = function(ev)
        local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
        end

        map("gd", vim.lsp.buf.definition, "Goto definition")
        map("gD", vim.lsp.buf.declaration, "Goto declaration")
        map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cf", function()
            vim.lsp.buf.format({ async = true })
        end, "Format buffer")
        map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
    end,
})
