# nvim-minimax

A **mini.nvim-first** Neovim config for **Neovim 0.11+/0.12**, built on the
built-in `vim.pack` plugin manager. `snacks.nvim` is a quality-of-life layer;
a few external plugins cover LSP / completion / git. Structure is modelled on
the [MiniMax](https://github.com/nvim-mini/MiniMax) reference config.

## Running it

Runs under its own [`NVIM_APPNAME`][appname], isolated from the main config. An
alias is defined in `~/.aliases`:

```sh
nvim-mm            # == NVIM_APPNAME=nvim-minimax nvim
nvim-mm <file>     # open <file> with this config
```

**First launch** clones plugins via `vim.pack` (a moment), then:
- Run `:TSUpdate` if parsers didn't auto-install (they install on demand per filetype).
- Run `:Mason` and install the language servers + formatters (see below).
- `:restart` once things settle.

## Layout

```
init.lua              globals, autocmd/packchanged helpers, now/later loaders,
                      netrw disable, the mini.diff style knob (Config.diff_style),
                      and the mini.basics baseline (runs before plugin/ files)
plugin/10_options.lua all option choices (overrides basics freely) + autocmds
plugin/20_keymaps.lua general + two-key <Leader> mappings; leader group clues
plugin/30_mini.lua    the other 23 mini.nvim modules (now/later split)
plugin/40_plugins.lua colorschemes, treesitter, LSP, blink.cmp, conform, mason,
                      Neogit, nvim-tree, snacks.nvim
after/ftplugin/markdown.lua  buffer-local Markdown behaviour (spell/wrap/fold,
                             a mini.surround link surrounding) — filetype example
after/lsp/lua_ls.lua  per-server LSP override (merged over nvim-lspconfig defaults)
snippets/all.json            global snippets (VSCode format) — always available
snippets/lua.json            Lua-only snippets — filetype example
```

Files in `plugin/` are auto-sourced by Neovim at startup in alphabetical order.
`after/ftplugin/` and `after/lsp/` follow Neovim's own `after/` convention.

## Snippets

VSCode-format snippet files, loaded by **blink.cmp** (mini.snippets is off). This
uses blink's native mechanism with no extra config: blink scans `<config>/snippets`
and keys files by name — `all.json` is blink's default global key, `lua.json` is
Lua-only, etc. So:

- `snippets/all.json` — offered in every filetype (`cdate`, `ctime`, `cdtm`).
- `snippets/lua.json` — offered only in Lua (`l`, `req`, `fn`).

Add `snippets/<filetype>.json` for more. Two notes on the MiniMax origin: its
snippet examples target *mini.snippets*, so (1) the global file is `all.json`
here rather than mini's `global.json`, and there's no `after/snippets/` (that's a
mini.snippets convention, not blink's); (2) MiniMax's `lua.json` "remove prefixes"
entry is dropped, since blink doesn't understand it.

## Plugins (13 `vim.pack` repos)

The 11 requested — mini.nvim, snacks.nvim, blink.cmp (pinned to `v1.10.2` for its
prebuilt Rust binary), friendly-snippets, Neogit, nvim-lspconfig, nvim-treesitter,
nvim-treesitter-textobjects, conform.nvim, mason.nvim, nvim-tree.lua — plus two
colorschemes: **kanagawa** (active) and **nord**. Modern Neogit needs no plenary.

### mini.nvim modules (24)

ai · surround · pairs · move · splitjoin · statusline · tabline · hipatterns ·
clue · bracketed · visits · jump · jump2d · misc · basics · pick · extra · files ·
starter · notify · icons · diff · git · bufremove

### snacks.nvim modules (8)

gitbrowse · indent · words · bigfile · quickfile · input · scratch · statuscolumn

### Handled without a plugin

- **Trailing whitespace** — `BufWritePre` autocmd (10_options.lua), scoped to skip
  markdown/diff/commit buffers so it never makes noisy diffs.
- **Commenting** — built-in `gc` / `gcc` (no mini.comment).
- **Window maximize** — `MiniMisc.zoom()` on `<Leader>oz` (no zen plugin).
- **Colorscheme** — external (kanagawa/nord), not a mini.hues theme.

## Completion & LSP

- **blink.cmp** does completion (mini.completion/snippets/keymap are left off).
  Its capabilities are advertised to every server via `vim.lsp.config('*', ...)`.
  Snippets come from friendly-snippets through blink's built-in `vim.snippet` support.
- **Native LSP**: `vim.lsp.enable({...})` for explicitly-named servers; nvim-lspconfig
  supplies defaults; per-server tweaks live in `after/lsp/`. No mason-lspconfig.
- Install binaries once with `:Mason` — servers: `lua-language-server`,
  `typescript-language-server`, `json-lsp`, `yaml-language-server`,
  `bash-language-server`; formatters: `stylua`, `prettierd`, `shfmt`.

## The one decision left open: mini.diff style

`Config.diff_style` in `init.lua` is the single knob:

| Value      | mini.diff shows…            | snacks.statuscolumn git component |
| ---------- | --------------------------- | --------------------------------- |
| `"number"` | coloured **line number**    | **off** (`right = { "fold" }`)    |
| `"sign"`   | mark in the **sign column** | **on**  (`right = { "fold", "git" }`) |

Defaults to `"number"`. Flip that one value to `"sign"` — both `mini.diff` and
`snacks.statuscolumn` read it, nothing else to change.

## Key mappings

`<Leader>` is `<Space>`; `mini.clue` shows options as you type. Groups: `b`uffer,
`e`xplore/edit, `f`ind, `g`it, `l`anguage, `o`ther, `v`isits. A few highlights:

| Key          | Action                                    |
| ------------ | ----------------------------------------- |
| `<Leader>ff` / `fg` | Find files / live grep (mini.pick) |
| `<Leader>fn` | Fuzzy notification history (MiniNotify→MiniPick) |
| `<Leader>ee` | Toggle nvim-tree                          |
| `<Leader>ed` | mini.files (editable explorer)            |
| `<Leader>gg` | Neogit                                    |
| `<Leader>go` | Toggle mini.diff overlay                  |
| `<Leader>gB` | Open in remote (snacks.gitbrowse)         |
| `<Leader>lf` | Format (conform, LSP fallback)            |
| `<Leader>oz` | Maximize window (MiniMisc.zoom)           |

Motions: `f/F/t/T` (mini.jump), `<CR>` (mini.jump2d label jump — kept distinct so
they never clash), `<C-hjkl>` window nav + `<M-hjkl>` insert/cmdline nav (mini.basics).

[appname]: https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME
