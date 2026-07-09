# nvim-minimal

A standalone, minimal Neovim config for **Neovim 0.12+**, kept separate from the
main LazyVim config in `../nvim`.

## Running it

It runs under its own [`NVIM_APPNAME`][appname], so it never touches the main
config's state (`~/.config/nvim`, `~/.local/share/nvim`, …). An alias is defined
in `~/.aliases`:

```sh
nvim-min            # == NVIM_APPNAME=nvim-minimal nvim
nvim-min <file>     # opens <file> with this config
```

First launch bootstraps everything: `vim.pack` clones the plugins and Mason
installs the language servers. Give it a moment, then `:restart`.

## Stack

| Concern            | Choice                                                    |
| ------------------ | --------------------------------------------------------- |
| Plugin manager     | `vim.pack` (built into Neovim 0.12)                       |
| Plugin set         | [mini.nvim](https://github.com/echasnovski/mini.nvim)     |
| Colourscheme       | [nord.nvim](https://github.com/gbprod/nord.nvim)          |
| LSP client         | native `vim.lsp` (`vim.lsp.config` / `vim.lsp.enable`)    |
| LSP server configs | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)|
| LSP server install | [mason.nvim](https://github.com/mason-org/mason.nvim) (enabled explicitly — no mason-lspconfig) |
| Undo history       | built-in `nvim.undotree` (`:packadd`, no third-party plugin) |
| Syntax / folding   | nvim-treesitter (`master` branch)                         |

### How the LSP pieces fit together

They're not interchangeable — each does one job:

- **nvim-lspconfig** ships the config recipes (launch command, filetypes, root
  markers, defaults) per server. Just data; installs and enables nothing.
- **mason.nvim** installs the server *binaries*.
- **`vim.lsp.enable(name)`** turns a server on; it starts lazily when a matching
  filetype opens. Overrides go through `vim.lsp.config(name, {...})`.

`config/lsp.lua` installs missing binaries via Mason's registry API and then
enables servers by name. That's what `mason-lspconfig` automated for us; doing
it by hand keeps it explicit (and shows why the Mason ↔ lspconfig name
translation, e.g. `lua-language-server` ↔ `lua_ls`, is needed).

## Layout

```
init.lua                 leader keys + module loading order
lua/config/options.lua   editor options (ported from the main config)
lua/config/plugins.lua   vim.pack install + mini.nvim / nord / treesitter setup
lua/config/lsp.lua       mason + native LSP + buffer-local LSP keymaps
lua/config/keymaps.lua   general keymaps (find / explorer / git / toggles)
lua/config/autocmds.lua  autocmds
ftplugin/javascript.lua  buffer-local JS settings + <localleader>r run-with-node
ftplugin/markdown.lua    buffer-local Markdown prose settings + checkbox toggle
```

## Filetype-local config (`ftplugin/`)

Files under `ftplugin/<filetype>.lua` are auto-sourced whenever a buffer of that
filetype loads — the idiomatic home for *buffer-local* settings and mappings
(use `vim.opt_local` and `{ buffer = true }`, and set `vim.b.undo_ftplugin` so
they revert cleanly). Two examples are included:

- **`ftplugin/javascript.lua`** — 2-space indent, `textwidth=80`, and
  `<localleader>r` to run the file with node in a terminal split.
- **`ftplugin/markdown.lua`** — soft prose wrapping, spell-check, conceal,
  display-line `j`/`k`, and `<localleader>t` to toggle a task checkbox.

`<localleader>` is `\` (see `init.lua`); it's the conventional prefix for these
per-filetype actions. Mirror `javascript.lua` into `typescript.lua` /
`typescriptreact.lua` to extend the same behaviour to TS.

## Managing plugins

- **Update:** `:packupdate` — review the diff in the confirmation tab, `:write`
  to apply, then `:restart`.
- **Add:** add a `{ src = "…" }` entry to `lua/config/plugins.lua` and restart.
- Tree-sitter parsers rebuild automatically (a `PackChanged` autocmd runs
  `:TSUpdate` when the plugin changes).

## Keymaps

Leader is `<Space>`. `mini.clue` shows what's available as you type a prefix.

| Key            | Action                              |
| -------------- | ----------------------------------- |
| `<leader>ff`   | Find files                          |
| `<leader>fg`   | Live grep                           |
| `<leader>fb`   | Buffers                             |
| `<leader>fr`   | Recent files                        |
| `<leader>fd`   | Diagnostics                         |
| `<leader>e`    | File explorer (current file's dir)  |
| `<leader>gb`   | Git blame (also `<leader>ub`)       |
| `<leader>gd`   | Toggle inline diff overlay          |
| `<leader>ca`   | Code action                         |
| `<leader>cr`   | Rename symbol                       |
| `<leader>cf`   | Format buffer                       |
| `<leader>uu`   | Toggle undotree panel (built-in)    |
| `<leader>p`    | (visual) paste without yanking      |

Neovim 0.11's default LSP maps also apply: `K` hover, `grn` rename, `gra` code
action, `grr` references, `gri` implementation, `gO` document symbols.

## Not ported from the main config

The main config's `onecommand.nvim` and `maximize.nvim` plugins are left out to
keep this minimal and mini-centric. Git blame is provided by `mini.git`
(`<leader>ub`/`gb`) rather than `git-blame.nvim`.

[appname]: https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME
