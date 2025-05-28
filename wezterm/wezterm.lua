local wezterm = require 'wezterm'
local config = {}
config.color_scheme = 'Monokai (terminal.sexy)'
config.font = wezterm.font("Hack Nerd Font Mono Regular")
config.window_background_opacity = 0.70
config.window_decorations = "NONE"
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
    {
        key = '1',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '2',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '3',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '4',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '5',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '6',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '7',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '8',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '9',
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    },
}

return config
