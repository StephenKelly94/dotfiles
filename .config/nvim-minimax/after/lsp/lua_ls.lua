-- ┌───────────────────────────────┐
-- │ Per-server LSP config: lua_ls  │
-- └───────────────────────────────┘
--
-- Files at `after/lsp/<name>.lua` return a config table that Neovim merges on
-- top of nvim-lspconfig's defaults for that server (the `after/` directory is
-- read last, so this wins). Equivalent to calling `vim.lsp.config('lua_ls',...)`
-- but co-located per server. See `:h vim.lsp.config()` and `:h vim.lsp.Config`.
--
-- Tuned for editing this Neovim config: teach lua_ls about the LuaJIT runtime,
-- the Neovim API, and the mini.nvim/Config globals so editing the config files
-- doesn't produce a wall of "undefined global" warnings.
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
      workspace = {
        ignoreSubmodules = true,
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
      diagnostics = {
        globals = {
          "vim",
          "Config",
          "MiniIcons",
          "MiniPick",
          "MiniExtra",
          "MiniFiles",
          "MiniDiff",
          "MiniGit",
          "MiniNotify",
          "MiniBufremove",
          "MiniVisits",
          "MiniMisc",
          "Snacks",
        },
      },
    },
  },
}
