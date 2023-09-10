local wezterm = require 'wezterm'

local config = {}

config.enable_scroll_bar = false
config.enable_tab_bar = false
config.check_for_updates = false
config.window_close_confirmation = 'NeverPrompt'
config.force_reverse_video_cursor = true
config.font = wezterm.font_with_fallback {
    'DejaVu Sans Mono',
    'Noto Color Emoji',
}
config.font_size = 12
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- 120 fps is choppy at 120hz
config.max_fps = 255

return config
