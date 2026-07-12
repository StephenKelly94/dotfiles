-- ┌──────────────────────────┐
-- │ Built-in Neovim behaviour │
-- └──────────────────────────┘
--
-- mini.basics (set up in init.lua, before this file) provides the baseline:
-- number, mouse, ignore/smartcase, undofile, listchars, pumheight, translucent
-- pum/floats, etc. Because basics runs first, THIS file is the single home for
-- all option choices: add whatever you like below, and it overrides basics
-- cleanly (no ordering gotcha). Below are just the extras basics doesn't set.

-- <Leader> must be set before any mapping is created (20_keymaps / 30_mini run
-- after this file). Space is roomy and doesn't shadow a useful motion.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Extras basics doesn't set. (To override something basics DOES set — e.g.
-- turn off transparency with `vim.o.winblend = 0` — just add it here; basics
-- already ran in init.lua, so this wins.)
vim.o.colorcolumn = "+1" -- highlight the column just past 'textwidth'
vim.o.scrolloff = 6 -- keep some context above/below the cursor
vim.o.winborder = "single" -- default border for all floating windows (matches
-- basics' win_borders='single' split fill-chars set in init.lua)

-- Folding: Tree-sitter aware, but start fully unfolded. Parsers are installed
-- in 40_plugins.lua; without one, 'foldexpr' quietly yields no folds.
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = "" -- use the folded lines' own highlighting
vim.o.foldlevelstart = 99

-- ┌─────────────┐
-- │ Autocommands │
-- └─────────────┘

-- Don't continue comment leaders on `o`/`O` and don't auto-wrap comments. Done
-- on FileType so it wins over ftplugins that re-add these flags.
Config.new_autocmd("FileType", nil, function()
  vim.cmd("setlocal formatoptions-=c formatoptions-=o")
end, "Sane formatoptions")

-- Trim trailing whitespace on save.
--
-- Scoped deliberately to avoid noisy diffs: skipped for filetypes where trailing
-- whitespace is meaningful (markdown: two trailing spaces = hard line break;
-- diff/gitcommit/patch buffers) and for non-file/binary buffers. The cursor
-- view is saved/restored so the edit is invisible to you.
local trim_skip = {
  markdown = true,
  diff = true,
  gitcommit = true,
  gitrebase = true,
  patch = true,
}
Config.new_autocmd("BufWritePre", "*", function(ev)
  if vim.bo[ev.buf].binary or vim.bo[ev.buf].buftype ~= "" then
    return
  end
  if trim_skip[vim.bo[ev.buf].filetype] then
    return
  end
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(view)
end, "Trim trailing whitespace")

-- Diagnostics display. Deferred so `vim.diagnostic` isn't sourced at startup.
Config.later(function()
  vim.diagnostic.config({
    severity_sort = true,
    underline = { severity = { min = "HINT", max = "ERROR" } },
    signs = { severity = { min = "WARN", max = "ERROR" } },
    virtual_text = { current_line = true, severity = { min = "WARN", max = "ERROR" } },
    float = { border = "single", source = true },
    update_in_insert = false,
  })
end)

-- Note: commenting uses Neovim's built-in `gc`/`gcc` (0.10+) — no mini.comment.
