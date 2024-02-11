-- -- override/extend lazyvim default config

-- A fancy, configurable, notification manager for NeoVim
-- https://github.com/rcarriga/nvim-notify
return {
  "rcarriga/nvim-notify",
  keys = {
    -- stylua: ignore
    { "<leader>sN", function() require("telescope").extensions.notify.notify() end, desc = "Show Notifications", },
  },
  config = function()
    require("telescope").load_extension("notify")
  end,
  opts = {
    fps = 75,
    stages = "slide",
    render = "wrapped-compact",
    timeout = 2000,
  },
}
