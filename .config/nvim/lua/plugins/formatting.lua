return {
    {
        "stevearc/conform.nvim",
        opts = function()
            local opts = {
                format = {
                    timeout_ms = 3000,
                    async = false, -- not recommended to change
                    quiet = false, -- not recommended to change
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    fish = { "fish_indent" },
                    sh = { "shfmt" },
                },
                formatters = {
                    injected = { options = { ignore_errors = true } },
                    shfmt = {
                      prepend_args = { "-i", "4", "-ci" },
                    },
                },
            }
            return opts
        end
    }
}

