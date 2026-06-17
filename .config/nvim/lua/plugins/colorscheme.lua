-- Colorscheme follows the shared theme switcher (~/.config/theme), written by
-- the `theme` script. Maps the canonical theme name -> neovim colorscheme.
-- New nvim instances pick up the current theme on startup.
local function active_colorscheme()
    local default = "onedark"
    local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
    local f = io.open(config_home .. "/theme", "r")
    if not f then
        return default
    end
    local name = vim.trim(f:read("*l") or "")
    f:close()

    local map = {
        ["catppuccin-frappe"] = "catppuccin-frappe",
        ["github-dark"] = "github_dark",
        ["tokyonight"] = "tokyonight-storm",
    }
    return map[name] or default
end

return {
    { "projekt0n/github-nvim-theme", lazy = true },
    { "rebelot/kanagawa.nvim", lazy = true },
    { "navarasu/onedark.nvim", lazy = true },
    { "folke/tokyonight.nvim", lazy = true },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = active_colorscheme(),
        },
    },
}
