local wezterm = require('wezterm')

local module = {}

local function profile_default(config)
    config.scrollback_lines = 1000
    config.color_scheme = 'Hivacruz'

    -- config.font = wezterm.font({
    --     family = 'FiraCode Nerd Font',
    --     weight = 450,
    --     stretch = 'Normal',
    --     style = 'Normal'
    -- })

    config.font = wezterm.font_with_fallback({{
        -- Use Fira Code and delegate symbols to Symbols Nerd Font below so I can scale the symbols
        family = 'Fira Code',
        weight = 450, -- AKA Retina
        stretch = 'Normal',
        style = 'Normal'
    }, {
        family = 'Noto Color Emoji'
    }, {
        family = 'Symbols Nerd Font Mono',
        scale = 1.2
    }})

    config.hide_tab_bar_if_only_one_tab = true
    config.harfbuzz_features = {'calt=0', 'clig=0', 'liga=0'}
end

local function profile_transient(config)
    config.initial_rows = 17
    config.initial_cols = 194
end

local profiles = {
    ['default'] = profile_default,
    ['transient'] = {profile_default, profile_transient}
}

function module:apply_to_config(config)
    config.unix_domains = {{
        name = 'transient'
    }}
end

function module:add_profile_config(config, profile)
    p = profiles[profile]
    if p == nil then
        p = profiles['default']
    end

    if type(p) == 'function' then
        p(config)
        return
    end

    for _, f in pairs(p) do
        f(config)
    end
end

return module
