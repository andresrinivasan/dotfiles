-- Based on https://github.com/wez/wezterm/discussions/2537#discussioncomment-3829655
local wezterm = require('wezterm')
local dim_schema = require('dim_schema')

local module = {}

local function appearance_color_scheme(focused)
    local scheme = 'dark'

    -- if wezterm.gui then
    --   local appearance = wezterm.gui.get_appearance()
    --   if appearance:find 'Light' then
    --     scheme = 'light'
    --   end
    -- end

    if focused then
        return scheme .. "_focus"
    end

    return scheme
end

local function apply_color_scheme(window)
    local focused = window:is_focused()
    local scheme = appearance_color_scheme(focused)
    local overrides = window:get_config_overrides() or {}
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
end

function module:apply_to_config(config)
    local dark_focus = wezterm.color.get_builtin_schemes()[config.color_scheme]
    local dark = dim_schema:dim(dark_focus, function(name, color)
        if name == 'background' then
            return color
        end

        return wezterm.color.parse(color):darken(0.5)
    end)

    local light_focus = wezterm.color.get_builtin_schemes()['Default Light (base16)']
    local light = wezterm.color.get_builtin_schemes()['Default Light (base16)']
    light.background = wezterm.color.parse(light.background):darken(0.2)

    config.color_schemes = {
        ['dark'] = dark,
        ['light'] = light,
        ['dark_focus'] = dark_focus,
        ['light_focus'] = light_focus
    }
    config.color_scheme = appearance_color_scheme(false)

    wezterm.on('window-config-reloaded', function(window, pane)
        apply_color_scheme(window)
    end)

    wezterm.on('window-focus-changed', function(window, pane)
        apply_color_scheme(window)
    end)
end

return module
