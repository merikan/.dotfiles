-- plugin for a code outline window
-- https://github.com/stevearc/aerial.nvim
if true then return {} end --disable
return {
  "stevearc/aerial.nvim",
  cmd = "AerialToggle",
  keys = {
    {
      "<leader>co",
      "<cmd>AerialToggle<cr>",
      desc = "Toggle Outline",
      mode = { "n", "v" },
      silent = true,
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("aerial").setup {
      backends = {
        ["_"] = { "lsp", "treesitter" },
        java = { "lsp" },
      },

      -- attach_mode = "global", -- "window" or "global"
      -- layout = {
      --   placement = "window", -- "window" or "edge"
      -- },
    }
  end,
}
