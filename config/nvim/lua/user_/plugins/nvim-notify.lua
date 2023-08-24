-- A fancy, configurable, notification manager for NeoVim
-- https://github.com/rcarriga/nvim-notify
local M = { "rcarriga/nvim-notify" }

function M.config()
  local notify = require("notify")

  notify.setup({
    background_colour = "Normal",
    fps = 60,
    icons = {
      DEBUG = " ",
      ERROR = " ",
      INFO = "",
      TRACE = "✎ ",
      WARN = " ",
    },
    level = 2,
    minimum_width = 30,
    render = "default",
    stages = "static",
    timeout = 2000,
    top_down = true,
  })

  vim.notify = notify
end

return M
