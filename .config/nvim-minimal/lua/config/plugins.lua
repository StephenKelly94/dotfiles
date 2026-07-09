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
    -- LSP: server configurations (nvim-lspconfig) + binary installer (mason).
    -- Servers are enabled explicitly in config/lsp.lua via vim.lsp.enable().
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    -- Tree-sitter, `main` branch. On this branch nvim-treesitter is *only* a
    -- parser installer/updater (requires Neovim 0.12): highlighting and folding
    -- are provided by Neovim natively (vim.treesitter.start / foldexpr). The
    -- old `master` branch bundled the highlight/indent glue itself.
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main",
    },
})

-- Rebuild Tree-sitter parsers whenever the plugin itself is updated (parser
-- definitions may have changed). Neovim ships parsers for C/Lua/Markdown/Vim/
-- Vimdoc; everything else is installed below.
vim.api.nvim_create_autocmd("PackChanged", {
    desc = "Update Tree-sitter parsers after nvim-treesitter changes",
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
            pcall(function()
                require("nvim-treesitter").update()
            end)
        end
    end,
})

-- Activate Neovim's built-in undotree plugin (ships with 0.12, not loaded by
-- default). Gives us :Undotree with zero third-party dependencies; the toggle
-- keymap lives in config/keymaps.lua (<leader>uu).
vim.cmd.packadd("nvim.undotree")

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

-- Tree-sitter parsers (`main`-branch API). install() is a no-op for parsers
-- that are already present, and runs asynchronously — on a fresh machine give
-- it a moment, then reopen the file (or :restart) for highlighting to kick in.
later(function()
    require("nvim-treesitter").install({
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
    })
end)

-- Native Tree-sitter highlighting: start it for any buffer whose language has
-- an installed parser (pcall swallows the "no parser" case). This is the
-- built-in vim.treesitter.start() the nvim-treesitter docs point to; it could
-- equally live in ftplugin/<ft>.lua, but one autocmd covers every language.
vim.api.nvim_create_autocmd("FileType", {
    desc = "Start Tree-sitter highlighting when a parser is available",
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})
