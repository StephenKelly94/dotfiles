local function toggle_fugitive_blame()
  if vim.bo.filetype == "fugitiveblame" then
    vim.cmd("close")
  else
    vim.cmd("Git blame")
  end
end

return {
  {
    'tpope/vim-fugitive',
    config = function ()
      vim.keymap.set('n',  "<leader>gB", toggle_fugitive_blame, {desc = "Blame File" })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame_opts = {
        delay = 0,
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']h', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [h]unk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [h]unk' })

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage Hunk' })
        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset Hunk' })
        -- normal mode
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Stage Hunk' })
        map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Reset Hunk' })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'Preview Hunk' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff Against Index' })
        map('n', '<leader>gD', function()
          gitsigns.diffthis '@'
        end, { desc = 'Diff Against Last Commit' })
        map('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = 'Blame Line' })
        map('n', '<leader>gsd', gitsigns.toggle_deleted, { desc = 'Toggle Git Show Deleted' })
      end,
    },
  },
}
