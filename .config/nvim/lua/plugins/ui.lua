return {
    -- It's called figlet
    {
        "folke/snacks.nvim",
        opts = {
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
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                offsets = {
                    {
                        filetype = "undotree",
                        text = "Undotree",
                        highlight = "PanelHeading",
                        padding = 1,
                    },
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                    {
                        filetype = "dapui_scopes",
                        text = "NVIM DAP",
                        highlight = "PanelHeading",
                    },
                },
            },
        },
    }
}
