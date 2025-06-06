local wezterm = require 'wezterm'
local config = {}
config.color_scheme = 'Monokai (terminal.sexy)'
config.colors = { background = '#161714' }
config.font = wezterm.font("Hack Nerd Font Mono Regular")
config.window_background_opacity = 0.70
config.window_decorations = "NONE"
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

config.keys = {}
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'SUPER',
        action = wezterm.action.DisableDefaultAssignment,
    })
end

return config
