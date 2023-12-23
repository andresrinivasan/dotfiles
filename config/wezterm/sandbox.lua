local wezterm = require 'wezterm'

local module = {}

local function is_array(o)
    if o ~= nil and type(o) == "table" and o[1] ~= nil then
        return true
    end

    return false
end

local function dim_color(c)
    return c
end

local function dim_array(a)
    return a
end

local function dim_table(table)
    local dimmed = {}

    for i, v in pairs(table) do
        if type(v) == "string" then
            dimmed[i] = dim_color(v)
        elseif is_array(v) then
            dimmed[i] = dim_array(v)
        else
            dimmed[i] = dim_table(v)
        end
    end

    return dimmed
end

function module:apply_to_config(config)
    -- wezterm.on('test-test', function(window, pane)
    --     local overrides = window:get_config_overrides() or {}
    --     if not overrides.text_background_opacity then
    --         overrides.text_background_opacity = 0.1
    --     else
    --         overrides.text_background_opacity = nil
    --     end
    --     window:set_config_overrides(overrides)
    -- end)

    -- config.keys = {{
    --     key = 'B',
    --     mods = 'CTRL',
    --     action = wezterm.action.EmitEvent 'test-test'
    -- }}

    -- print(config.color_scheme)
    s = wezterm.color.get_builtin_schemes()[config.color_scheme]
    d = dim_table(s)
    print(d)
    -- for i, v in pairs(d) do
    --     print(string.format("%s: %s", i, v))
    -- end
end

return module

