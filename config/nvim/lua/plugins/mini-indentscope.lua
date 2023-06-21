-- override/extend lazyvim default config

-- active indent guide and indent text objects
return {
  "echasnovski/mini.indentscope",
  opts = {
    draw = {
      -- turn of blingbling
      animation = require("mini.indentscope").gen_animation.none(),
    },
  },
}
