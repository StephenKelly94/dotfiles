-- ┌──────────────────────────────────────────────────────────────────────┐
-- │ mini.nvim-first Neovim config (Neovim 0.11+/0.12), built on vim.pack.  │
-- └──────────────────────────────────────────────────────────────────────┘
--
-- Structure is modelled on the MiniMax reference config
-- (https://github.com/nvim-mini/MiniMax):
--
-- ├ init.lua           This file: globals, helpers, plugin manager bootstrap.
-- ├ plugin/            Sourced automatically at startup, in alphabetical order.
-- │ ├ 10_options.lua   Built-in Neovim options + a few autocmds.
-- │ ├ 20_keymaps.lua   Custom general + <Leader> mappings.
-- │ ├ 30_mini.lua      mini.nvim module configuration (the bulk of the config).
-- │ └ 40_plugins.lua   Everything outside mini.nvim (LSP, cmp, git, tree, ...).
-- └ after/lsp/         Per-server LSP overrides (see after/lsp/lua_ls.lua).
--
-- Philosophy: mini.nvim first, snacks.nvim as a quality-of-life layer, and a
-- small set of external plugins for LSP/completion/git that mini doesn't cover.
--
-- Runs under its own NVIM_APPNAME=nvim-minimax (see the `nvim-mm` alias in
-- ~/.aliases and this folder's README.md), so it never touches the main config.

-- Disable netrw *before* it loads, so nvim-tree (set up in 40_plugins) owns the
-- file-explorer role. This must happen here in init.lua (runs before the plugin
-- loading phase) rather than in a deferred callback.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ┌────────────────────────────────────────────────┐
-- │ Global config table + shared autocommand helper │
-- └────────────────────────────────────────────────┘
-- `_G.Config` is a global scratch table used to pass data/helpers between the
-- plugin/ files. Usable as either `Config` or `_G.Config`.
_G.Config = {}

-- One augroup for every autocommand this config creates, plus a small helper.
local gr = vim.api.nvim_create_augroup("custom-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, {
    group = gr,
    pattern = pattern,
    callback = callback,
    desc = desc,
  })
end

-- ┌───────────────────────┐
-- │ mini.diff / git glue  │
-- └───────────────────────┘
-- ONE knob for the mini.diff visualization style. This is read in two places:
--   * 30_mini.lua  -> mini.diff `view.style`
--   * 40_plugins.lua -> whether snacks.statuscolumn renders a git component
--
-- Rule (as requested):
--   'number' -> mini.diff colours the LINE NUMBER; snacks git component OFF
--              (the coloured number is the change indicator, no sign column art)
--   'sign'   -> mini.diff puts a MARK in the SIGN COLUMN; snacks git component ON
--              (snacks renders the MiniDiffSign marks — see its `git.patterns`)
--
-- To flip: change this single value to 'sign'. Nothing else needs editing.
Config.diff_style = "number"

-- ┌────────────────┐
-- │ Plugin manager │
-- └────────────────┘
-- Built-in `vim.pack` (Neovim 0.12). `vim.pack.add()` installs (if missing) and
-- loads plugins; the resolved revisions are recorded in a lockfile in the data
-- dir. Update all plugins with `:lua vim.pack.update()` (then `:write` in the
-- confirmation tab). See `:h vim.pack`.
--
-- Build/post-install hooks: vim.pack has NO `data.build`-style field in a spec.
-- The mechanism is the `PackChanged` event (`:h vim.pack-events`). The helper
-- below wraps it; nvim-treesitter uses it in 40_plugins.lua to run :TSUpdate.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  Config.new_autocmd("PackChanged", "*", function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    -- Make sure the plugin is actually loaded before running the hook.
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback(ev.data)
  end, desc)
end

-- Install mini.nvim first: it powers most of the config *and* provides
-- `mini.misc` used by the loading helpers just below.
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- ┌─────────────────┐
-- │ Loading helpers │
-- └─────────────────┘
-- Two-stage loading, borrowed from MiniMax (`:h MiniMisc.safely()`):
--   * now()         - run immediately; use for first-screen-draw things
--                     (colorscheme, statusline, tabline, starter, icons).
--   * later()       - run just after the first draw; use for everything else.
--   * now_if_args() - now() when Neovim was opened on a file (`nvim file`),
--                     otherwise later(). Keeps `nvim file` behaving correctly
--                     while keeping a bare `nvim` startup snappy.
-- `safely` also catches errors per-block, so one broken section warns instead
-- of taking down the whole config.
local misc = require("mini.misc")
Config.now = function(f)
  misc.safely("now", f)
end
Config.later = function(f)
  misc.safely("later", f)
end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
