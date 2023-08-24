
_G.prequire = require "config.utils".prequire


local keymap = require "config.utils".keymap
_G.keymap = keymap.map
_G.buf_keymap = keymap.buf_map
