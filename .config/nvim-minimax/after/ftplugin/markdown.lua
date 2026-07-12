-- ┌─────────────────────────┐
-- │ Filetype config example │
-- └─────────────────────────┘
--
-- Files at `after/ftplugin/<filetype>.lua` run whenever a buffer's 'filetype'
-- becomes <filetype> (here 'markdown', i.e. '*.md'). Put buffer/window-local
-- settings and mappings here — use `vim.bo`/`setlocal`, not the global `vim.o`.
-- It's also the right place for buffer-local mini.nvim config (see
-- `:h mini.nvim-buffer-local-config`). Adapted from the MiniMax example.

-- Prose-friendly: spell-check and soft wrap for this window.
vim.cmd("setlocal spell wrap")

-- Fold via Tree-sitter for Markdown specifically.
vim.cmd("setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()")

-- Neovim's built-in Markdown ftplugin maps a buffer-local `gO` (table of
-- contents). Remove it so mini.basics' global `gO` (open line above) wins here.
-- pcall'd so it's harmless if that buffer-local map isn't present.
pcall(vim.keymap.del, "n", "gO", { buffer = 0 })

-- Buffer-local mini.surround: add a Markdown-link surrounding on `L`.
--   `saiwL` + <link> + <CR> - wrap a word as [word](link)
--   `sdL`                    - delete the surrounding link
--   `srLL` + <link> + <CR>   - replace the link target
vim.b.minisurround_config = {
  custom_surroundings = {
    L = {
      input = { "%[().-()%]%(.-%)" },
      output = function()
        local link = require("mini.surround").user_input("Link: ")
        return { left = "[", right = "](" .. link .. ")" }
      end,
    },
  },
}
