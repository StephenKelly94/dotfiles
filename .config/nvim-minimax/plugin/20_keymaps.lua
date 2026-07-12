-- ┌─────────────────┐
-- │ Custom mappings │
-- └─────────────────┘
--
-- Mappings follow a two-key <Leader> scheme (borrowed from MiniMax): the first
-- key is a semantic group, the second is the action — e.g. <Leader>f is "find",
-- <Leader>ff is "find files". `mini.clue` (30_mini.lua) surfaces these as you
-- type. RHS strings use `<Cmd>...<CR>` so the underlying function need not exist
-- when the mapping is created (a lazy-loading trick).

-- ── General mappings ────────────────────────────────────────────────────────
local nmap = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

-- Paste the last yank linewise above/below (e.g. `yiw` then `]p`).
nmap("[p", '<Cmd>exe "put! " . v:register<CR>', "Paste above")
nmap("]p", '<Cmd>exe "put "  . v:register<CR>', "Paste below")

-- Note: <C-hjkl> window nav and <M-hjkl> insert/cmdline nav come from
-- mini.basics (mappings.windows / move_with_alt) — set up in init.lua.

-- ── Leader groups (fed to mini.clue as extra clues) ──────────────────────────
-- Add an entry here whenever you introduce a new group prefix.
Config.leader_group_clues = {
  { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<Leader>e", desc = "+Explore/Edit" },
  { mode = "n", keys = "<Leader>f", desc = "+Find" },
  { mode = "n", keys = "<Leader>g", desc = "+Git" },
  { mode = "n", keys = "<Leader>l", desc = "+Language" },
  { mode = "n", keys = "<Leader>o", desc = "+Other" },
  { mode = "n", keys = "<Leader>v", desc = "+Visits" },

  { mode = "x", keys = "<Leader>g", desc = "+Git" },
  { mode = "x", keys = "<Leader>l", desc = "+Language" },
}

-- ── Leader mapping helpers ───────────────────────────────────────────────────
local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set("x", "<Leader>" .. suffix, rhs, { desc = desc })
end
-- Map a <Leader> suffix in several modes at once (for maps that make sense in
-- both Normal and Visual, like git-at-cursor / git-at-selection).
local map_leader = function(modes, suffix, rhs, desc)
  vim.keymap.set(modes, "<Leader>" .. suffix, rhs, { desc = desc })
end

-- stylua: ignore start

-- b is for 'Buffer' (mini.bufremove) --------------------------------------
nmap_leader('ba', '<Cmd>b#<CR>',                                 'Alternate')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>',         'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>',  'Delete!')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>',        'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

-- e is for 'Explore/Edit' --------------------------------------------------
-- ee = mini.files (editable Miller-column explorer); eE = nvim-tree sidebar.
-- ec = fuzzy-pick any file in the config dir; ei/eo/ek/em/ep jump to a specific
-- config file directly.
local edit_plugin_file = function(filename)
  return ('<Cmd>edit %s/plugin/%s<CR>'):format(vim.fn.stdpath('config'), filename)
end
nmap_leader('ee', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', 'Files (mini.files)')
nmap_leader('eE', '<Cmd>NvimTreeToggle<CR>',                    'Tree (nvim-tree)')
nmap_leader('ef', '<Cmd>NvimTreeFindFileToggle<CR>',           'Tree at file')
nmap_leader('ec', function()
  MiniPick.builtin.files({}, { source = { cwd = vim.fn.stdpath('config'), name = 'Config' } })
end,                                                            'Edit config (picker)')
nmap_leader('en', '<Cmd>lua MiniNotify.show_history()<CR>',     'Notifications history')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>',                     'init.lua')
nmap_leader('eo', edit_plugin_file('10_options.lua'),          'Options config')
nmap_leader('ek', edit_plugin_file('20_keymaps.lua'),          'Keymaps config')
nmap_leader('em', edit_plugin_file('30_mini.lua'),             'MINI config')
nmap_leader('ep', edit_plugin_file('40_plugins.lua'),          'Plugins config')

-- f is for 'Find' (mini.pick / mini.extra) ---------------------------------
nmap_leader('fb', '<Cmd>Pick buffers<CR>',                      'Buffers')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>',       'Diagnostics (all)')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>',   'Diagnostics (buffer)')
nmap_leader('ff', '<Cmd>Pick files<CR>',                        'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>',                    'Grep live')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>',       'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>',                         'Help tags')
nmap_leader('fn', '<Cmd>lua Config.pick_notifications()<CR>',   'Notifications (fuzzy)')
nmap_leader('fr', '<Cmd>Pick resume<CR>',                       'Resume last picker')
nmap_leader('fv', '<Cmd>Pick visit_paths<CR>',                  'Visit paths (cwd)')
nmap_leader('fV', '<Cmd>Pick visit_paths cwd=""<CR>',           'Visit paths (all)')

-- g is for 'Git' (Neogit client, mini.git info, mini.diff hunks, snacks browse)
-- gs / gB work in Normal and Visual (act on the line or the selected range).
nmap_leader('gg', '<Cmd>Neogit<CR>',                            'Neogit')
nmap_leader('gc', '<Cmd>Neogit commit<CR>',                     'Commit')
nmap_leader('gd', '<Cmd>Git diff<CR>',                          'Diff (mini.git)')
nmap_leader('gl', '<Cmd>Git log --oneline<CR>',                 'Log (mini.git)')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>',     'Toggle diff overlay')
map_leader({ 'n', 'x' }, 'gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at cursor/selection')
map_leader({ 'n', 'x' }, 'gB', '<Cmd>lua Snacks.gitbrowse()<CR>',       'Browse in remote')

-- l is for 'Language' (native LSP + conform) -------------------------------
-- These deliberately live under <Leader>l rather than the built-in `gr*` maps.
nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>',      'Code action')
nmap_leader('ld', '<Cmd>lua vim.diagnostic.open_float()<CR>',    'Diagnostic float')
nmap_leader('lf', '<Cmd>lua require("conform").format({ async = true })<CR>', 'Format')
nmap_leader('lh', '<Cmd>lua vim.lsp.buf.hover()<CR>',            'Hover')
nmap_leader('li', '<Cmd>lua vim.lsp.buf.implementation()<CR>',   'Implementation')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',           'Rename')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>',       'References')
nmap_leader('ls', '<Cmd>lua vim.lsp.buf.definition()<CR>',       'Definition')
nmap_leader('lt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>',  'Type definition')
xmap_leader('lf', '<Cmd>lua require("conform").format({ async = true })<CR>', 'Format selection')

-- o is for 'Other' ---------------------------------------------------------
nmap_leader('oz', '<Cmd>lua MiniMisc.zoom()<CR>',               'Zoom window (toggle)')
nmap_leader('os', '<Cmd>lua Snacks.scratch()<CR>',              'Scratch buffer')
nmap_leader('oS', '<Cmd>lua Snacks.scratch.select()<CR>',       'Scratch select')

-- v is for 'Visits' (mini.visits) ------------------------------------------
nmap_leader('vv', '<Cmd>lua MiniVisits.add_label("core")<CR>',    'Add "core" label')
nmap_leader('vV', '<Cmd>lua MiniVisits.remove_label("core")<CR>', 'Remove "core" label')
nmap_leader('vl', '<Cmd>lua MiniVisits.add_label()<CR>',          'Add label')
nmap_leader('vL', '<Cmd>lua MiniVisits.remove_label()<CR>',       'Remove label')
nmap_leader('vc', '<Cmd>Pick visit_paths filter="core" cwd=""<CR>', 'Core visits (all)')
nmap_leader('vC', '<Cmd>Pick visit_paths filter="core"<CR>',       'Core visits (cwd)')
-- stylua: ignore end
