-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- OPTIONS
config.default_prog = { '/usr/bin/zsh' }
config.use_dead_keys = false
config.enable_scroll_bar= true
-- config.disable_default_key_bindings = true
-- config.unix_domains = {
--     {
--         name = 'unix',
--         no_serve_automatically = true,
--     },
-- }
-- config.default_gui_startup_args = { 'connect', 'unix' }
-- config.default_domain = 'unix'


-- STYLE
config.color_scheme = 'catppuccin-frappe'
config.window_background_opacity = 0.95
-- config.color_scheme = 'Tokyo Night Storm'
config.font = wezterm.font {
    family = 'FiraCode Nerd Font',
    -- https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets
    harfbuzz_features = { 'zero', 'cv14', 'ss03', 'ss08' }
}
config.font_size = 10.0
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Show which key table is active in the status area
-- Show the name of the workspace in the bottom right
-- with the status of the leader
wezterm.on('update-right-status', function(window, _)
    local name = window:active_key_table()

    local workspace_name = window:active_workspace() == "default" and "Default" or window:active_workspace()
    local key_table = name or "Default"

    local leader_pressed_color = window:leader_is_active() and "Yellow" or "Green"

    local right_status = wezterm.format {
        'ResetAttributes',
        { Foreground = { AnsiColor = 'Black' } },
        { Background = { AnsiColor = 'Blue' } },
        { Text = "  Mode: " .. key_table .. "  "},
    }
    local left_status = wezterm.format {
        { Foreground = { AnsiColor = 'Black' } },
        { Background = { AnsiColor = leader_pressed_color } },
        { Text = "  " .. workspace_name  .. "  " },
    }
    window:set_right_status(right_status)
    window:set_left_status(left_status)
end)

-- KEYS
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
        key = 'a',
        mods = 'LEADER|CTRL',
        action = act.SendKey { key = 'a', mods = 'CTRL' },
    },
    -- MOVEMENT
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up'   },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    -- PANE/SPLIT
    {
        key = 'x',
        mods = 'LEADER',
        action = act.CloseCurrentPane { confirm = true },
    },
    {
        key = 'q',
        mods = 'LEADER',
        action = act.PaneSelect { mode = 'Activate' },
    },
    {
        key = 's',
        mods = 'LEADER|SHIFT',
        action = act.SplitPane { direction = 'Down' },
    },
    {
        key = 'v',
        mods = 'LEADER',
        action = act.SplitPane { direction = 'Right' },
    },
    -- TABS
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 't',
        mods = 'LEADER',
        action = act.ShowLauncherArgs { flags = "TABS" }
    },
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, _pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    -- SESSIONS/WORKSPACES
    {
        key = '.',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for workspace',
            action = wezterm.action_callback(function(_window, _pane, line)
                if line then
                    wezterm.mux.rename_workspace(
                        wezterm.mux.get_active_workspace(),
                        line
                    )
                end
            end),
        },
    },
    {
        key = 'w',
        mods = 'LEADER',
        action = act.ShowLauncherArgs {
            flags = "WORKSPACES",
            title = 'Workspaces'
        }
    },
    -- MODES
    -- Enter resize mode
    {
        key = 'r',
        mods = 'LEADER',
        action = act.ActivateKeyTable {
            name = 'resize_pane',
            one_shot = false,
        },
    },
}

for i = 1, 8 do
    -- CTRL+ALT + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = act.ActivateTab(i - 1),
    })
end

config.key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the key assignments above.
    resize_pane = {
        { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
        { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },

        { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
        { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },

        { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
        { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },

        { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
        { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },

        -- Cancel the mode by pressing escape or enter
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'Enter', action = 'PopKeyTable' },
    },
}

-- and finally, return the configuration to wezterm
return config
