local setup, tokyonight = pcall(require, "tokyonight")
if not setup then
    print("No comment installed")
    return
end

tokyonight.setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    transparent = true, -- Enable this to disable setting the background color
    dim_inactive = true, -- dims inactive windows
})
