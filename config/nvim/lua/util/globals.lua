
local utils = require ".util.utils"
_G.prequire = utils.prequire


local keymap = utils.keymap
_G.keymap = keymap.map
_G.buf_keymap = keymap.buf_map
