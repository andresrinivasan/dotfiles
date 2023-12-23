-- Pull in the wezterm API
local wezterm = require('wezterm')

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

local function setDefaults()
    config.color_scheme = 'Hivacruz'

    -- FiraCode Retina per `wezterm ls-fonts --list-system`
    config.font = wezterm.font({
        family = 'FiraCode Nerd Font Mono',
        weight = 450,
        stretch = "Normal",
        style = "Normal"
    })
    
    config.hide_tab_bar_if_only_one_tab = true
end

setDefaults()

local inactive_window = require('inactive_window')
inactive_window:apply_to_config(config)

return config
