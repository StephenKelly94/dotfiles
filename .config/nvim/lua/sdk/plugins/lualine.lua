local setup, lualine = pcall(require, "lualine")
if not setup then
    print("No lualine installed")
    return
end

lualine.setup({
    options = {
        theme = "nord",
    }
})
