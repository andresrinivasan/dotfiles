local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

wezterm.on('test-test', function(window, pane)
    local hotkey = wezterm.mux.get_domain('hotkey')
    wezterm.mux.spawn_window {
        domain = {
            DomainName = 'hotkey'
        }
    }
end)

config.keys = {{
    key = 'B',
    mods = 'CTRL',
    action = wezterm.action.EmitEvent 'test-test'
}}

config.unix_domains = {{
    name = "hotkey"
}}

return config
