-- auto save changes
-- https://github.com/akinsho/Pocco81/auto-save.nvim
return {
  "Pocco81/auto-save.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    require("auto-save").setup {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
    }
  end,
}
