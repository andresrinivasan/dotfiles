-- Pull in the wezterm API
local wezterm = require('wezterm')

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

local profiles = require('profiles')
profiles:apply_to_config(config)
profiles:add_profile_config(config, os.getenv("WEZTERM_PROFILE"))

local inactive_window = require('inactive_window')
inactive_window:apply_to_config(config)

return config
