local wezterm = require 'wezterm' --[[@as Wezterm]]
local function get_rgba(color)
    local r, g, b, a = wezterm.color.parse(color):linear_rgba()
    r = math.floor(r * 255 + 0.5)
    g = math.floor(g * 255 + 0.5)
    b = math.floor(b * 255 + 0.5)
    a = math.floor(a * 255 + 0.5)
    return { r = r, g = g, b = b, a = a }
end

local function get_random_background(background_dir)
    local io = require("io")

    local images = {}

    for file in io.popen('dir "' .. background_dir .. '" /b'):lines() do
        if file:match("%.png$") or file:match("%.jpg$") then
            table.insert(images, background_dir .. file)
        end
    end

    if #images > 0 then
        return images[math.random(#images)]
    end
    return nil
end


local terminal_backgrounds = os.getenv("USERPROFILE") .. "/terminal-backgrounds/"

local blk_color = get_rgba("black")
local gray_color = wezterm.color.parse 'gray'

local config = wezterm.config_builder()
config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }

config.color_scheme = 'Monokai (terminal.sexy)'
config.font = wezterm.font("Hack Nerd Font Mono Regular")
config.window_frame = {
    font = wezterm.font { family = 'Inter', weight = 'Bold' },
    active_titlebar_bg = string.format("rgba(%d, %d, %d, %.2f)",
        blk_color.r,
        blk_color.g,
        blk_color.b,
        0.6)
}

config.colors = {
    background = 'black',
    cursor_bg = 'white',
    tab_bar = {
        background = "rgba(0, 0, 0, 0)",
        inactive_tab_edge = 'gray',
        inactive_tab = {
            bg_color = "rgba(0, 0, 0, 0)",
            fg_color = 'gray',
        },
        new_tab = {
            bg_color = "rgba(0, 0, 0, 0)",
            fg_color = 'gray'
        }
    }
}

config.window_decorations = "RESIZE"
--[[config.background = {
    {
        source = {
            --File = get_random_background(terminal_backgrounds)
        },
        repeat_y = 'NoRepeat',
        repeat_x = 'NoRepeat',
        opacity = 0.8,
        height = "Contain",
        horizontal_align = "Right"
    }
}]] --
--config.window_background_image = get_random_background(terminal_backgrounds)
config.window_background_opacity = 0.70
-- config.debug_key_events = true
config.keys = {
    -- {
    --     key = 'Tab',
    --     mods = 'CTRL',
    --     action = wezterm.action.DisableDefaultAssignment,
    -- },
    {
        key = 'h',
        mods = 'CTRL|SHIFT|ALT',
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" })
    },
    {
        key = 'v',
        mods = 'CTRL|SHIFT|ALT',
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })
    },
    {
        key = 'p',
        mods = 'ALT',
        action = wezterm.action.EmitEvent("print-colors")
    },
    {
        key = 'c',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.CloseCurrentPane { confirm = true }
    },
    {
        key = 'h', -- left
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'j', -- down
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
        key = 'K', -- up
        mods = 'CTRL',
        action = wezterm.action({ ActivatePaneDirection = "Up" }),
    },
    -- {
    --     key = 'l', -- right
    --     mods = 'CTRL|SHIFT',
    --     action = wezterm.action({ ActivatePaneDirection = "Right" }),
    --     --        action = wezterm.action.ActivatePaneDirection 'Right',
    -- },
}

config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true


wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})

    window:gui_window():maximize()
end)

return config
