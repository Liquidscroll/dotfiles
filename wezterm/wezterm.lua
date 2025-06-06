local wezterm = require 'wezterm'
local config = {}

-- Appearance settings
config.color_scheme = 'Monokai (terminal.sexy)'
config.colors = { background = '#161714' }
config.font = wezterm.font("Hack Nerd Font Mono Regular")
config.window_background_opacity = 0.70
config.window_decorations = "NONE"
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Keep more lines in scrollback so we can review terminal history
config.scrollback_lines = 10000

-- Default hyperlink rules plus mapping GH-<num> to GitHub issues
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[GH-(\d+)]],
  format = 'https://github.com/wez/wezterm/issues/$1',
})

-- Key assignments table
config.keys = {}

-- Disable default SUPER+number assignments
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'SUPER',
    action = wezterm.action.DisableDefaultAssignment,
  })
end

-- Split panes using SUPER+Enter (horizontal) and SUPER+SHIFT+Enter (vertical)
table.insert(config.keys, {
  key = 'Enter',
  mods = 'SUPER',
  action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
})
table.insert(config.keys, {
  key = 'Enter',
  mods = 'SUPER|SHIFT',
  action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
})

return config
