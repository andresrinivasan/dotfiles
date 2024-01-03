-- Based on https://github.com/wez/wezterm/discussions/2537#discussioncomment-3829655
local wezterm = require('wezterm')
local dim_schema = require('dim_schema')

local module = {}

local function appearance_color_scheme(focused)
    if focused then
        return 'active'
    end

    return 'inactive'
end

local function apply_color_scheme(window)
    local focused = window:is_focused()
    local scheme = appearance_color_scheme(focused)
    local overrides = window:get_config_overrides() or {}
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
end

function module:apply_to_config(config)
    local active = wezterm.color.get_builtin_schemes()[config.color_scheme]
    local inactive = dim_schema:dim(active, function(name, color)
        if name == 'background' then
            return color
        end

        return wezterm.color.parse(color):darken(0.6)
        -- return wezterm.color.parse(color):adjust_hue_fixed_ryb(180)
        -- return wezterm.color.parse(color):saturate(0)
    end)

    config.color_schemes = {
        ['inactive'] = inactive,
        ['active'] = active,
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
