-- ┌────────────────────┐
-- │ mini.nvim modules  │
-- └────────────────────┘
--
-- mini.nvim is a library of independent modules, each enabled with
-- `require('mini.xxx').setup(config?)` and exposing a global `MiniXxx` table.
-- This config enables 24 of them, split into two loading stages:
--   * now()   - needed for the first screen draw (icons, statusline, ...).
--   * later() - everything else, run just after the first draw.
--
-- Deliberately NOT enabled (handled elsewhere, per design):
--   * mini.completion / mini.snippets / mini.keymap - completion is blink.cmp.
--   * mini.comment - use built-in `gc` (Neovim 0.10+).
--   * mini.trailspace - trimming is a BufWritePre autocmd (10_options.lua).
local now, later = Config.now, Config.later

-- ════════════════════════════════════════════════════════════════ now() ═══

-- Icons. Used by mini.pick/files/statusline, nvim-tree, blink, etc.
now(function()
  require("mini.icons").setup()
  -- Feed mini.icons to plugins that still ask for 'nvim-web-devicons'.
  -- Called synchronously so the shim exists BEFORE nvim-tree is set up in
  -- 40_plugins.lua (that file is sourced after this one) — no need to install
  -- nvim-web-devicons at all.
  MiniIcons.mock_nvim_web_devicons()
  -- Nicer LSP "kind" icons (function/variable/...) in completion menus.
  MiniIcons.tweak_lsp_kind()
end)

-- Common option/mapping/autocmd presets.
--   * options.basic = true    - the sensible defaults (number, mouse,
--                               ignorecase/smartcase, splitright, undofile,
--                               cursorline, signcolumn, ...).
--   * options.extra_ui = true - opinionated UI extras: pumheight, translucent
--                               completion menu + floating windows (pumblend /
--                               winblend), listchars, and syntax-on. This is
--                               why 10_options.lua no longer sets pumheight.
--   * mappings.windows        - <C-hjkl> to move between windows.
--   * mappings.move_with_alt  - <M-hjkl> to move the cursor in Insert and
--                               Command-line modes. (Distinct from mini.move
--                               below, which uses <M-hjkl> in Normal/Visual
--                               mode — different modes, no clash.)
now(function()
  require("mini.basics").setup({
    options = { basic = true, extra_ui = true },
    mappings = { windows = true, move_with_alt = true },
  })
end)

-- Notifications (upper-right). Route vim.notify through it too.
now(function()
  require("mini.notify").setup()
  vim.notify = MiniNotify.make_notify()
end)

-- Statusline and tabline (buffers shown along the top; navigate with [b / ]b).
now(function()
  require("mini.statusline").setup()
end)
now(function()
  require("mini.tabline").setup()
end)

-- Start screen (shown on a bare `nvim`).
now(function()
  require("mini.starter").setup()
end)

-- ══════════════════════════════════════════════════════════════ later() ═══

-- mini.extra first: it registers extra pickers/textobjects/highlighters used by
-- mini.pick, mini.ai and mini.hipatterns below.
later(function()
  require("mini.extra").setup()
end)

-- a/i textobjects, incl. next/last variants. Extended with Tree-sitter:
--   * `aF`/`iF` -> around/inside a function definition (needs a TS parser and
--                  nvim-treesitter-textobjects queries; both in 40_plugins.lua).
--   * `aB`/`iB` -> around/inside the whole buffer.
later(function()
  local ai = require("mini.ai")
  ai.setup({
    custom_textobjects = {
      F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      B = MiniExtra.gen_ai_spec.buffer(),
    },
    search_method = "cover", -- only match a covering textobject; use an/in, al/il to search
  })
end)

-- Add/delete/replace surroundings: `saiw)` , `sd)`, `sr)]`.
later(function()
  require("mini.surround").setup()
end)

-- Auto-insert/delete paired brackets and quotes.
later(function()
  require("mini.pairs").setup()
end)

-- Move lines/selections with <M-hjkl> in Normal/Visual mode.
later(function()
  require("mini.move").setup()
end)

-- Split/join argument lists with `gS`.
later(function()
  require("mini.splitjoin").setup()
end)

-- Highlight hex colours and TODO/FIXME/HACK/NOTE words inline.
later(function()
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- Next-key hints. Uses the <Leader> group descriptions from 20_keymaps.lua.
later(function()
  local clue = require("mini.clue")
  -- stylua: ignore
  clue.setup({
    clues = {
      Config.leader_group_clues,
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.square_brackets(),
      clue.gen_clues.windows({ submode_resize = true }),
      clue.gen_clues.z(),
    },
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = [[\]] },        -- mini.basics toggles
      { mode = "n", keys = "[" },          -- mini.bracketed
      { mode = "n", keys = "]" },
      { mode = "x", keys = "[" },
      { mode = "x", keys = "]" },
      { mode = "i", keys = "<C-x>" },      -- built-in completion
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "n", keys = "z" },
      { mode = "n", keys = "<C-w>" },      -- window commands
    },
  })
end)

-- `[`/`]` navigation for buffers, diagnostics, quickfix, conflicts, etc.
later(function()
  require("mini.bracketed").setup()
end)

-- Track visited files/directories; power the <Leader>v and <Leader>fv pickers.
later(function()
  require("mini.visits").setup()
end)

-- Enhanced f/F/t/T (multi-line, repeatable with `;`).
later(function()
  require("mini.jump").setup()
end)

-- Two-character label jump anywhere on screen.
-- Trigger is <CR> — intentionally distinct from mini.jump's f/F/t/T so the two
-- never clash. If <CR> is inconvenient (e.g. in your muscle memory), change
-- `start_jumping` below; just avoid f/F/t/T/; which mini.jump owns.
later(function()
  require("mini.jump2d").setup({ mappings = { start_jumping = "<CR>" } })
end)

-- Small utilities. `MiniMisc.zoom()` backs the <Leader>oz "maximize" mapping;
-- also enable auto project-root cd and cursor-position restore.
later(function()
  require("mini.misc").setup()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
end)

-- Fuzzy pickers (files/grep/buffers/help/...). Mapped under <Leader>f.
later(function()
  require("mini.pick").setup()

  -- Optional nicety: fuzzy-search notification history by feeding
  -- MiniNotify.get_all() into MiniPick.start(). Mapped to <Leader>fn.
  Config.pick_notifications = function()
    local notifs = MiniNotify.get_all()
    table.sort(notifs, function(a, b)
      return a.ts_update > b.ts_update
    end)
    local items = vim.tbl_map(function(n)
      return { text = n.msg:gsub("\n", " "), notif = n }
    end, notifs)
    MiniPick.start({ source = { name = "Notifications", items = items } })
  end
end)

-- Editable file explorer (Miller columns), with preview. Mapped under <Leader>e.
later(function()
  require("mini.files").setup({ windows = { preview = true } })
end)

-- Git change gutter + in-buffer diff overlay (<Leader>go).
-- `view.style` is driven by the single knob in init.lua (see Config.diff_style):
--   'number' colours the line number; 'sign' uses the sign column.
later(function()
  require("mini.diff").setup({
    view = { style = Config.diff_style },
  })
end)

-- Git integration separate from the gutter: `:Git` command, blame, log, and
-- `MiniGit.show_at_cursor()` (<Leader>gs). Neogit (40_plugins.lua) sits on top
-- as the full client; mini.git is the lightweight always-on layer.
later(function()
  require("mini.git").setup()
end)

-- Delete/wipeout buffers without closing their window/split. Under <Leader>b.
later(function()
  require("mini.bufremove").setup()
end)
