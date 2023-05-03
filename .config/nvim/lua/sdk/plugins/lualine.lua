local setup, lualine = pcall(require, "lualine")
if not setup then
    print("No lualine installed")
    return
end

lualine.setup({
    options = {
        theme = "tokyonight",
    },
    sections = {
        lualine_b = {
            {
                'diagnostics',
                symbols = {error = '', warn = '', info = '', hint = ''},
            }
        }
    }

})
