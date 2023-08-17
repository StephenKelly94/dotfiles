return {

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
    {
        "telescope.nvim",
        opts = function(_, opts)
            opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
                mappings = {
                    i = {
                        ["<M-q>"] = require("trouble.providers.telescope").open_selected_with_trouble,
                        ["<C-q>"] = require("trouble.providers.telescope").open_with_trouble,
                    },
                    n = {
                        ["<M-q>"] = require("trouble.providers.telescope").open_selected_with_trouble,
                        ["<C-q>"] = require("trouble.providers.telescope").open_with_trouble,
                    },
                },
            })
        end,
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
                require("telescope").load_extension("fzf")
            end,
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
