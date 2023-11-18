return {
    {
        "stephenkelly94/onecommand.nvim",
        keys = {
            {
                "<leader>xc",
                function ()
                    require('onecommand').prompt_run_command()
                end,
                desc = "Run command",
            },
            {
                "<leader>xh",
                function ()
                    require('onecommand').view_history()
                end,
                desc = "View command history",
            },
            {
                "<leader>xl",
                function ()
                    require('onecommand').show_last_command_output()
                end,
                desc = "Show last command output",
            },
        },
        -- opts = {
        --     ui = {
        --         line_numbers = false,
        --         relative_numbers = false,
        --         modifiable = false,
        --         popup = {
        --             footer ="TEST"
        --         },
        --         command = {
        --             command_limit = 1
        --         }
        --     }
        -- }
    },
    {
        "tpope/vim-fugitive",
    },
    {
        "f-person/git-blame.nvim",
        keys = {
            {
                "<leader>ub",
                "<cmd>GitBlameToggle<cr>",
                desc = "Toggle Git Blame",
            },
        },
    },
    {
        "declancm/maximize.nvim",
        keys = {
            {
                "<leader>um",
                function()
                    require("maximize").toggle()
                end,
                desc = "Toggle Maximize",
            },
        },
    },
    {
        "folke/zen-mode.nvim",
        keys = {
            {
                "<leader>uz",
                function()
                    require("zen-mode").toggle()
                end,
                desc = "Toggle Zen Mode",
            },
        },
        opts = {
            window = {
                width = 0.75,
                height = 1,
            },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            {
                "<leader>cu",
                "<cmd>UndotreeToggle<cr>",
                desc = "Undo Tree Toggle",
            },
        },
    },
    -- Disable flash on search
    {
        "folke/flash.nvim",
        opts = {
            modes = {
                search = {
                    enabled = false,
                },
            },
        },
    },
}
