-- https://wezfurlong.org/wezterm/config/files.html
-- https://wezfurlong.org/wezterm/config/lua/general.html

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- font
config.font = wezterm.font('JetBrains Mono') -- JetBrains Mono is bundled and default
config.font_size = 14.0

config.color_scheme = 'Gruvbox dark, soft (base16)'

config.hide_tab_bar_if_only_one_tab = true

-- you don't have to dribble with the alt key for macos like you have
-- to do with alacritty and kitty
-- this is the truth, alt != option
--    https://wezfurlong.org/wezterm/config/keyboard-concepts.html#macos-left-and-right-option-key
--    The default behavior is to treat the left Option key as the Alt modifier with no composition
--    effects, while the right Option key performs composition (making it approximately equivalent
--    to AltGr on other operating systems).
--
return config
