-- Plugin installation (vim.pack) and non-LSP plugin setup.
--
-- vim.pack is Neovim 0.12's built-in plugin manager. `add()` installs anything
-- missing on first launch and puts every plugin on the runtimepath
-- synchronously, so the code below can configure them straight away. Updates
-- are pulled on demand with `:packupdate` (review the diff, `:write` to apply).

vim.pack.add({
    -- Primary plugin set. Tracks its default branch (`main`).
    { src = "https://github.com/echasnovski/mini.nvim" },
    -- Nord colourscheme.
    { src = "https://github.com/gbprod/nord.nvim" },
    -- LSP: server configurations + installer + the bridge between them.
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    -- Tree-sitter. Pinned to `master`: the stable, classic-API branch (the
    -- `main` branch is a work-in-progress rewrite with a different API).
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "master",
    },
})

-- Rebuild Tree-sitter parsers whenever the plugin itself is installed/updated.
vim.api.nvim_create_autocmd("PackChanged", {
    desc = "Run :TSUpdate after nvim-treesitter changes",
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter" and ev.data.kind ~= "delete" then
            vim.cmd("TSUpdate")
        end
    end,
})

-- mini.nvim's recommended two-stage loading (see :h MiniDeps-examples):
--   now()   - things needed for the first screen draw (colourscheme, UI)
--   later() - everything else, scheduled off the startup path
local function now(fn)
    fn()
end
local function later(fn)
    vim.schedule(fn)
end

-- ── Draw-critical: colourscheme and core UI ────────────────────────────────
now(function()
    require("nord").setup({
        transparent = false,
        styles = {
            comments = { italic = true },
        },
    })
    vim.cmd.colorscheme("nord")
end)

now(function()
    require("mini.icons").setup()
    -- Let plugins that still ask for nvim-web-devicons resolve to mini.icons.
    MiniIcons.mock_nvim_web_devicons()

    require("mini.statusline").setup()
    require("mini.tabline").setup()
end)

-- ── Deferred: everything else ──────────────────────────────────────────────

-- Text editing
later(function()
    require("mini.ai").setup() -- richer a/i text objects
end)
later(function()
    require("mini.pairs").setup() -- auto-close brackets/quotes
end)
later(function()
    require("mini.surround").setup() -- add/delete/replace surroundings
end)
later(function()
    require("mini.move").setup() -- move lines/selections with Alt-hjkl
end)
later(function()
    require("mini.bracketed").setup() -- [ / ] navigation for many targets
end)

-- Completion (uses the native LSP client under the hood)
later(function()
    require("mini.completion").setup()
end)

-- Pickers & file explorer
later(function()
    require("mini.pick").setup()
    require("mini.extra").setup() -- extra pickers (oldfiles, diagnostics, ...)
end)
later(function()
    require("mini.files").setup()
end)

-- Git & diff
later(function()
    require("mini.diff").setup() -- signs + inline diff overlay
end)
later(function()
    require("mini.git").setup() -- `:Git` command, blame, at-cursor info
end)

-- Visual niceties
later(function()
    require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
    })
end)
later(function()
    require("mini.notify").setup()
    vim.notify = MiniNotify.make_notify()
end)
later(function()
    require("mini.starter").setup()
end)

-- Keybinding hints (a which-key replacement from the mini set)
later(function()
    local clue = require("mini.clue")
    clue.setup({
        triggers = {
            { mode = "n", keys = "<Leader>" },
            { mode = "x", keys = "<Leader>" },
            { mode = "n", keys = "g" },
            { mode = "x", keys = "g" },
            { mode = "n", keys = "'" },
            { mode = "n", keys = "`" },
            { mode = "n", keys = '"' },
            { mode = "i", keys = "<C-r>" },
            { mode = "n", keys = "<C-w>" },
            { mode = "n", keys = "z" },
            { mode = "x", keys = "z" },
            { mode = "n", keys = "[" },
            { mode = "n", keys = "]" },
        },
        clues = {
            clue.gen_clues.builtin_completion(),
            clue.gen_clues.g(),
            clue.gen_clues.marks(),
            clue.gen_clues.registers(),
            clue.gen_clues.windows(),
            clue.gen_clues.z(),
            -- Group labels for our leader menus.
            { mode = "n", keys = "<Leader>f", desc = "+Find" },
            { mode = "n", keys = "<Leader>g", desc = "+Git" },
            { mode = "n", keys = "<Leader>c", desc = "+Code" },
            { mode = "n", keys = "<Leader>u", desc = "+UI / Toggle" },
        },
    })
end)

-- Tree-sitter (classic `master`-branch API)
later(function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    })
end)
