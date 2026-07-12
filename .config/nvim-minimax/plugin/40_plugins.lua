-- ┌─────────────────────────┐
-- │ Plugins outside of mini  │
-- └─────────────────────────┘
--
-- Everything here is a non-mini plugin: the colorscheme, Tree-sitter, native
-- LSP wiring, blink.cmp completion, conform formatting, Mason, the Neogit git
-- client, nvim-tree, and the snacks.nvim quality-of-life layer.
--
-- Total vim.pack repos across the whole config: 13 = the 11 requested
-- (mini.nvim, snacks.nvim, blink.cmp, friendly-snippets, Neogit, nvim-lspconfig,
-- nvim-treesitter, nvim-treesitter-textobjects, conform.nvim, mason.nvim,
-- nvim-tree.lua) + 2 colorschemes (kanagawa, nord). mini.nvim itself is added
-- in init.lua. Note: modern Neogit no longer requires plenary.nvim.

local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Colorschemes ═══════════════════════════════════════════════════════════════
-- Two external themes installed; one active. This is the "own external theme"
-- from the design (mini.hues themes intentionally not used).
now(function()
  add({
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/gbprod/nord.nvim",
  })

  -- setup() is optional for both (they work from `:colorscheme` alone); called
  -- here so customization has an obvious home.
  require("kanagawa").setup({})
  require("nord").setup({})

  -- Active theme. To switch, change this line to one of:
  --   'nord'
  --   'kanagawa' / 'kanagawa-wave' / 'kanagawa-dragon' / 'kanagawa-lotus'
  vim.cmd.colorscheme("kanagawa")
end)

-- Tree-sitter ═════════════════════════════════════════════════════════════════
-- The engine is built into Neovim; these plugins add the missing parts:
--   * nvim-treesitter             - installs language parsers.
--   * nvim-treesitter-textobjects - query files for `@function.outer` etc.,
--                                    consumed by mini.ai (30_mini.lua, `aF`/`iF`).
--
-- Parsers are kept in sync with the plugin by running :TSUpdate whenever
-- nvim-treesitter is installed or updated. vim.pack has no `data.build`-style
-- spec hook, so this uses the PackChanged event (via Config.on_packchanged).
now_if_args(function()
  Config.on_packchanged("nvim-treesitter", { "install", "update" }, function()
    vim.cmd("TSUpdate")
  end, ":TSUpdate parsers")

  add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  })

  -- Install/highlight autocmd (used exactly as specified). For each opened
  -- buffer: resolve its language; if a parser is present, start highlighting;
  -- otherwise install the parser (if available) and bail — highlighting starts
  -- on the next open of that filetype.
  local ts = require("nvim-treesitter")
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match)
      if not lang then
        return
      end
      if not vim.treesitter.language.add(lang) then
        if vim.list_contains(ts.get_available(), lang) then
          ts.install(lang)
        end
        return
      end
      vim.treesitter.start(args.buf)
    end,
  })
end)

-- Completion: blink.cmp ═══════════════════════════════════════════════════════
-- blink.cmp is the completion engine (NOT mini.completion). It ships a prebuilt
-- Rust fuzzy-matching binary, so it is PINNED to a release tag to get that
-- binary (a branch/commit would require building it locally).
--
-- Snippet content comes from friendly-snippets; blink uses its built-in
-- `vim.snippet`-based expansion (snippets.preset = 'default').
now_if_args(function()
  add({ "https://github.com/rafamadriz/friendly-snippets" })
  add({ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" })

  require("blink.cmp").setup({
    keymap = { preset = "default" }, -- <C-space> open, <C-y> accept, <C-n>/<C-p> select
    appearance = { nerd_font_variant = "mono" },
    completion = { documentation = { auto_show = true } },
    signature = { enabled = true },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    -- Snippets: native vim.snippet + friendly-snippets. blink also loads our own
    -- VSCode-format files from `<config>/snippets/` with no extra config, keyed
    -- by filename: `all.json` -> every filetype (blink's default global key),
    -- `lua.json` -> Lua, etc. See the snippets/ directory.
    snippets = { preset = "default" },
    fuzzy = { implementation = "prefer_rust_with_warning" }, -- use the prebuilt binary
  })
end)

-- Language servers (native LSP) ═══════════════════════════════════════════════
-- Neovim is the LSP client; nvim-lspconfig only supplies per-server *defaults*
-- (cmd, filetypes, root markers). We use the native API directly:
--   * vim.lsp.config('*', {...}) - options merged into every server; here we
--                                   advertise blink.cmp's extra capabilities.
--   * vim.lsp.config('<name>', ...) / after/lsp/<name>.lua - per-server tweaks
--                                   (see after/lsp/lua_ls.lua).
--   * vim.lsp.enable({...})       - enable a handful of explicitly-named servers.
--
-- Server binaries are installed once via :Mason (see below). mason-lspconfig is
-- intentionally NOT used — enabling is explicit here.
now_if_args(function()
  add({ "https://github.com/neovim/nvim-lspconfig" })

  -- Give every server blink.cmp's completion capabilities.
  vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
  })

  -- Enable the servers you use. Install their binaries with :Mason (names in
  -- brackets): lua_ls [lua-language-server], ts_ls [typescript-language-server],
  -- jsonls [json-lsp], yamlls [yaml-language-server], bashls [bash-language-server].
  vim.lsp.enable({ "lua_ls", "ts_ls", "jsonls", "yamlls", "bashls" })
end)

-- Formatting: conform.nvim ════════════════════════════════════════════════════
-- Per-filetype formatters, falling back to the LSP formatter when no dedicated
-- CLI formatter is configured/available. Format on demand with <Leader>lf.
-- Install the CLI formatters via :Mason (e.g. stylua, prettierd, shfmt).
later(function()
  add({ "https://github.com/stevearc/conform.nvim" })

  require("conform").setup({
    default_format_opts = { lsp_format = "fallback" },
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      sh = { "shfmt" },
    },
  })
end)

-- Package manager: Mason ══════════════════════════════════════════════════════
-- Installs external tooling (LSP servers, formatters) for use inside Neovim.
-- Run `:Mason` to open the UI, then install the servers/formatters listed above.
now_if_args(function()
  add({ "https://github.com/mason-org/mason.nvim" })
  require("mason").setup()
end)

-- Git client: Neogit ══════════════════════════════════════════════════════════
-- Full-screen git UI on top of the always-on mini.git/mini.diff layer. Opened
-- with <Leader>gg. Its picker uses mini.pick (no telescope/plenary needed).
later(function()
  add({ "https://github.com/NeogitOrg/neogit" })
  require("neogit").setup({
    integrations = { mini_pick = true },
  })
end)

-- File tree: nvim-tree ════════════════════════════════════════════════════════
-- Sidebar tree (netrw was disabled in init.lua). Icons come from the
-- mini.icons devicons shim set up in 30_mini.lua. Toggle with <Leader>ee.
later(function()
  add({ "https://github.com/nvim-tree/nvim-tree.lua" })
  require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
  })
end)

-- Quality of life: snacks.nvim ════════════════════════════════════════════════
-- Eight snacks modules. `statuscolumn` renders a git component ONLY when
-- mini.diff is in 'sign' mode; in 'number' mode the line-number colouring is the
-- change indicator, so the git component is dropped (see Config.diff_style in
-- init.lua). This is the single point where the diff-style decision reaches snacks.
now(function()
  add({ "https://github.com/folke/snacks.nvim" })

  local statuscolumn_right = Config.diff_style == "sign" and { "fold", "git" } or { "fold" }

  require("snacks").setup({
    bigfile = { enabled = true }, -- disable heavy features on huge files
    quickfile = { enabled = true }, -- render the file before plugins load
    indent = { enabled = true }, -- indent guides + scope
    words = { enabled = true }, -- LSP reference highlight + [[ / ]] navigation
    input = { enabled = true }, -- pretty vim.ui.input
    scratch = { enabled = true }, -- persistent scratch buffers (<Leader>os)
    gitbrowse = { enabled = true }, -- open file/line in the remote (<Leader>gB)
    statuscolumn = { enabled = true, right = statuscolumn_right },
  })
end)
