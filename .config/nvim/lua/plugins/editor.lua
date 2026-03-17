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
        "f-person/git-blame.nvim",
        keys = {
            { "<leader>ub", function() vim.cmd('GitBlameToggle') end, desc = "Toggle git blame" },
        },
    },
    {
        "declancm/maximize.nvim",
        keys = {
            { "<leader>um", function() require("maximize").toggle() end, desc = "Toggle Maximize" },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            {
                "<leader>uu",
                "<cmd>UndotreeToggle<cr>",
                desc = "Undo Tree Toggle",
            },
        },
    },
}
