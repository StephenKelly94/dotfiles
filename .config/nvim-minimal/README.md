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
| LSP server install | [mason.nvim](https://github.com/mason-org/mason.nvim) + mason-lspconfig |
| Syntax / folding   | nvim-treesitter (`master` branch)                         |

## Layout

```
init.lua                 leader keys + module loading order
lua/config/options.lua   editor options (ported from the main config)
lua/config/plugins.lua   vim.pack install + mini.nvim / nord / treesitter setup
lua/config/lsp.lua       mason + native LSP + buffer-local LSP keymaps
lua/config/keymaps.lua   general keymaps (find / explorer / git)
lua/config/autocmds.lua  autocmds
```

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
| `<leader>p`    | (visual) paste without yanking      |

Neovim 0.11's default LSP maps also apply: `K` hover, `grn` rename, `gra` code
action, `grr` references, `gri` implementation, `gO` document symbols.

## Not ported from the main config

The main config's `undotree`, `onecommand.nvim`, `maximize.nvim` and
`git-blame.nvim` plugins are intentionally left out to keep this minimal and
mini-centric. Git blame is provided instead by `mini.git` on `<leader>ub`/`gb`.

[appname]: https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME
