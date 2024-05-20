-- Pull in the wezterm API
local wezterm = require('wezterm')

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.window_frame = {
  border_left_width = '0.1cell',
  border_right_width = '0.1cell',
  border_bottom_height = '0.1cell',
  border_top_height = '0.0cell',
  border_left_color = 'gray',
  border_right_color = 'gray',
  border_bottom_color = 'gray',
  border_top_color = 'gray',
}

local profiles = require('profiles')
profiles:apply_to_config(config)
profiles:add_profile_config(config, os.getenv("WEZTERM_PROFILE"))

local inactive_window = require('inactive_window')
inactive_window:apply_to_config(config)

-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
--   local pane_title = tab.active_pane.title
--   local user_title = tab.active_pane.user_vars.panetitle

--   if user_title ~= nil and #user_title > 0 then
--     pane_title = user_title
--   end

--   return {
--     {Background={Color="blue"}},
--     {Foreground={Color="white"}},
--     {Text=" " .. pane_title .. " "},
--   }
-- end)

-- wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
--   local zoomed = ''
--   if tab.active_pane.is_zoomed then
--     zoomed = '[Z] '
--   end

--   local index = ''
--   if #tabs > 1 then
--     index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
--   end

--   return "blah"
-- end)

-- local function get_current_working_dir(tab)
-- 	local current_dir = tab.active_pane.current_working_dir
-- 	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

-- 	return current_dir == HOME_DIR and "." or string.gsub(current_dir, "(.*[/\\])(.*)", "%2")
-- end


-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)


-- 	local title = string.format(" %s  %s ~ %s  ", "❯", get_current_working_dir(tab))


-- 	return {
-- 		{ Text = title },
-- 	}
-- end)

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  return "localhost"
end)

return config
