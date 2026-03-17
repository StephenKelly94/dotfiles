return {
  -- It's called figlet
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        hidden = true,
        ignored = false,
        sources = {
          files = {
            hidden = true,
          },
        },
        win = {
          input = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-f>"] = { "toggle_follow", mode = { "i", "n" } },
              ["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<c-i>"] = { "toggle_ignored", mode = { "i", "n" } },
              ["<c-m>"] = { "toggle_maximize", mode = { "i", "n" } },
              ["<c-p>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<c-w>"] = { "cycle_win", mode = { "i", "n" } },
            },
          },
        },
      },
      explorer = {
        hidden = true,
        ignored = false,
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
      { "<leader>sp", function() Snacks.picker.projects() end, desc = "Projects" },
    }
  },
}
