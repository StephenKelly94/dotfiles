return {
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>ub", desc = "Toggle git blame" },
            },
        },
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
