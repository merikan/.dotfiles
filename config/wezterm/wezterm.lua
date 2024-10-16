-- https://wezfurlong.org/wezterm/config/files.html
-- https://wezfurlong.org/wezterm/config/lua/general.html

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- font
config.font = wezterm.font('JetBrains Mono') -- JetBrains Mono is bundled and default
config.font_size = 14.0

config.color_scheme = 'Gruvbox dark, soft (base16)'

config.hide_tab_bar_if_only_one_tab = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

return config
