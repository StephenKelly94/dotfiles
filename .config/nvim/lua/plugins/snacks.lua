return {
  -- It's called figlet
  {
    "folke/snacks.nvim",
    opts = {
      win = {
        input = {
          keys = {
            ["<C-d>"] = { "inspect", mode = { "n", "i" } },
            ["<C-f>"] = { "toggle_follow", mode = { "i", "n" } },
            ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<C-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<C-m>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<C-p>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<C-w>"] = { "cycle_win", mode = { "i", "n" } },
          },
        },
      },
      indent = {
        animate = {
          enabled = false
        }
      },
      dashboard = {
        preset = {
          header = [[
  .-')     (`\ .-') /`.-. .-')   
 ( OO ).    `.( OO ),'\  ( OO )  
(_)---\_),--./  .--.  ,--. ,--.  
/    _ | |      |  |  |  .'   /  
\  :` `. |  |   |  |, |      /,  
 '..`''.)|  |.'.|  |_)|     ' _) 
.-._)   \|         |  |  .   \   
\       /|   ,'.   |  |  |\   \  
 `-----' '--'   '--'  `--' '--'  
                    ]]
        }
      },
      zen = {
        toggles = {
          dim = false
        },
        win = {
          style = {
            backdrop = { transparent = false },
          }
        }
      }
    },
    keys = {
      { "<leader>gd", function() vim.cmd('Gvdiff') end, desc="Diff current file" },
      { "<leader>ub", function() vim.cmd('GitBlameToggle') end, desc="Toggle git blame" },
      { "<leader>um", function() require("maximize").toggle() end, desc="Toggle Maximize" },
      { "<leader>sp", function() Snacks.picker.projects() end, desc = "Projects" },
    }
  },
}
