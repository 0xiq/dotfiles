local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Batman'

config.font_size = 16.0

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"

config.default_cursor_style = 'BlinkingBar'
config.animation_fps = 120
config.cursor_blink_rate = 650
config.cursor_blink_rate = 650

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

--keep at bottom 
return config
