-- ┌──────────────────────────┐
-- │ Built-in Neovim behaviour │
-- └──────────────────────────┘
--
-- Most sensible defaults (number, mouse, ignorecase/smartcase, splitright,
-- undofile, listchars, ...) are set by `mini.basics` with `options.basic = true`
-- in 30_mini.lua. This file only sets what mini.basics doesn't, plus a couple of
-- autocmds. Keeping it small avoids fighting mini.basics.

-- <Leader> must be set before any mapping is created (20_keymaps / 30_mini run
-- after this file). Space is roomy and doesn't shadow a useful motion.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI niceties not covered by mini.basics.
vim.o.colorcolumn = "+1" -- highlight the column just past 'textwidth'
vim.o.cursorline = true -- highlight the current line
vim.o.pumheight = 10 -- cap completion popup height
vim.o.scrolloff = 6 -- keep some context above/below the cursor
vim.o.signcolumn = "yes" -- always show the sign column (less horizontal jitter)
vim.o.winborder = "single" -- bordered floating windows (hover, rename, ...)

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
