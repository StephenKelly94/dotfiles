-- Language servers, the Neovim-0.11-native way.
--
-- mason.nvim installs the server binaries; nvim-lspconfig ships the per-server
-- configs in its `lsp/` directory; mason-lspconfig bridges the two and calls
-- `vim.lsp.enable()` for each installed server (automatic_enable, on by
-- default). Overrides go through `vim.lsp.config(<name>, {...})`, which layers
-- on top of lspconfig's defaults.
--
-- Order matters: mason and nvim-lspconfig must be set up / on the runtimepath
-- before mason-lspconfig.

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "ts_ls", -- typescript-language-server (papi-scraper is TypeScript)
        "jsonls",
        "yamlls",
        "bashls",
    },
    automatic_enable = true,
})

-- ── Per-server overrides ───────────────────────────────────────────────────
-- Teach lua_ls about the Neovim runtime and the globals used in this config so
-- editing it doesn't produce a wall of "undefined global" warnings.
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
