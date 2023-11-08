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
config.disable_default_key_bindings = true
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
config.force_reverse_video_cursor = true
config.font = wezterm.font {
    family = 'FiraCode Nerd Font',
    -- https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets
    harfbuzz_features = { 'zero', 'cv14', 'ss03', 'ss08' }
}

config.inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.7,
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
    local non_default_key_color = key_table ~= "Default" and "Yellow" or "Blue"

    local right_status = wezterm.format {
        'ResetAttributes',
        { Foreground = { AnsiColor = 'Black' } },
        { Background = { AnsiColor = non_default_key_color } },
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
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 5000 }
config.keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
        key = 'a',
        mods = 'LEADER|CTRL',
        action = act.SendKey { key = 'a', mods = 'CTRL' },
    },
    -- DEFUALT
    { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'Enter', mods = 'SHIFT|CTRL', action = act.ToggleFullScreen },
    { key = 'P', mods = 'CTRL', action = wezterm.action.ActivateCommandPalette },
    -- MOVEMENT
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up'   },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
    { key = 'f', mods = 'LEADER', action = act.Search { CaseInSensitiveString = "" } },
    { key = 'F', mods = 'LEADER', action = act.QuickSelect },
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
        mods = 'LEADER',
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
    { key = 'PageUp', mods = 'LEADER', action = act.ActivateCopyMode },
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
        -- Cancel the mode by pressing escape or enter
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'Enter', action = 'PopKeyTable' },

        { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
        { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },

        { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
        { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },

        { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
        { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },

        { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
        { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
    },
    search_mode = {
        { key = "Escape", mods = "NONE", action = act.CopyMode 'Close' },
        -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
        -- to navigate search results without conflicting with typing into the search area.
        { key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
    },
    copy_mode = {
        { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
        {
            key = 'Space',
            mods = 'NONE',
            action = act.CopyMode { SetSelectionMode = 'Cell' },
        },
        {
            key = '$',
            mods = 'NONE',
            action = act.CopyMode 'MoveToEndOfLineContent',
        },
        {
            key = '$',
            mods = 'SHIFT',
            action = act.CopyMode 'MoveToEndOfLineContent',
        },
        { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
        { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
        { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
        {
            key = 'F',
            mods = 'SHIFT',
            action = act.CopyMode { JumpBackward = { prev_char = false } },
        },
        {
            key = 'G',
            mods = 'SHIFT',
            action = act.CopyMode 'MoveToScrollbackBottom',
        },
        {
            key = 'M',
            mods = 'SHIFT',
            action = act.CopyMode 'MoveToViewportMiddle',
        },
        {
            key = 'O',
            mods = 'SHIFT',
            action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
        },
        {
            key = 'T',
            mods = 'SHIFT',
            action = act.CopyMode { JumpBackward = { prev_char = true } },
        },
        {
            key = 'V',
            mods = 'NONE',
            action = act.CopyMode { SetSelectionMode = 'Line' },
        },
        {
            key = 'V',
            mods = 'SHIFT',
            action = act.CopyMode { SetSelectionMode = 'Line' },
        },
        {
            key = '^',
            mods = 'NONE',
            action = act.CopyMode 'MoveToStartOfLineContent',
        },
        { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
        { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
        {
            key = 'd',
            mods = 'CTRL',
            action = act.CopyMode { MoveByPage = 0.5 },
        },
        {
            key = 'e',
            mods = 'NONE',
            action = act.CopyMode 'MoveForwardWordEnd',
        },
        {
            key = 'f',
            mods = 'NONE',
            action = act.CopyMode { JumpForward = { prev_char = false } },
        },
        {
            key = 'g',
            mods = 'NONE',
            action = act.CopyMode 'MoveToScrollbackTop',
        },
        { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
        { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
        { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
        {
            key = 'o',
            mods = 'NONE',
            action = act.CopyMode 'MoveToSelectionOtherEnd',
        },
        { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
        {
            key = 't',
            mods = 'NONE',
            action = act.CopyMode { JumpForward = { prev_char = true } },
        },
        {
            key = 'u',
            mods = 'CTRL',
            action = act.CopyMode { MoveByPage = -0.5 },
        },
        {
            key = 'v',
            mods = 'NONE',
            action = act.CopyMode { SetSelectionMode = 'Cell' },
        },
        {
            key = 'v',
            mods = 'CTRL',
            action = act.CopyMode { SetSelectionMode = 'Block' },
        },
        { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
        {
            key = 'y',
            mods = 'NONE',
            action = act.Multiple {
                { CopyTo = 'ClipboardAndPrimarySelection' },
                { CopyMode = 'Close' },
            },
        },
        { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
        { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
        { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent', },
        { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine', },
        { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
        { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        { key = '/', mods = 'SHIFT', action = wezterm.action { Search = { CaseSensitiveString = "" } } },
    },
}

-- and finally, return the configuration to wezterm
return config
