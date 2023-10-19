return {
    -- {
    --     "folke/noice.nvim",
    --     opts = {
    --         cmdline = {
    --             view = "cmdline",
    --         },
    --     },
    -- },
    {
        "folke/which-key.nvim",
        opts = {
            defaults = {
                ["<leader>gd"] = { "<cmd>Gvdiff<cr>", "Diff current file" },
            },
        },
    },
    -- {
    --     "nvimdev/dashboard-nvim",
    --     opts = function(_, opts)
    --         local logo = [[
    --               ********   *******     **   **
    --              **//////   /**////**   /**  **
    --             /**         /**    /**  /** **
    --             /*********  /**    /**  /****
    --             ////////**  /**    /**  /**/**
    --                    /**  /**    **   /**//**
    --              ********   /*******    /** //**
    --             ////////    ///////     //   //
    --         ]]
    --         logo = string.rep("\n", 8) .. logo .. "\n\n"
    --         opts.config.header = vim.split(logo, "\n")
    --         return opts
    --     end,
    -- },
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
