return {
    {
        "folke/which-key.nvim",
        opts = {
            defaults = {
                ["<leader>gd"] = { "<cmd>Gvdiff<cr>", "Diff current file" },
            },
        },
    },
    {
        "goolord/alpha-nvim",
        opts = function(_, opts)
            local logo = {
                "  ********   *******     **   **",
                " **//////   /**////**   /**  ** ",
                "/**         /**    /**  /** **  ",
                "/*********  /**    /**  /****   ",
                "////////**  /**    /**  /**/**  ",
                "       /**  /**    **   /**//** ",
                " ********   /*******    /** //**",
                "////////    ///////     //   // ",
            }
            opts.section.header.val = logo
        end,
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
    },
}
