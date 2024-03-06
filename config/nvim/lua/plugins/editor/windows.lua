
-- resize windows
-- https://github.com/anuvyklack/windows.nvim
return {
  "anuvyklack/windows.nvim",
  event = "WinNew",
  dependencies = {
    { "anuvyklack/middleclass" },
    { "anuvyklack/animation.nvim" },
  },
  keys = {
    { "<leader>wv", "<cmd>WindowsMaximizeVertically<cr>", desc = "Vertical Zoom" },
    { "<leader>wh", "<cmd>WindowsMaximizeHorizontally<cr>", desc = "Horizontal Zoom" },
    { "<leader>we", "<cmd>WindowsEqualize<cr>", desc = "Equalize Zoom" },
    { "<leader>wz", "<cmd>WindowsMaximize<cr>", desc = "Maximize window" },
    { "<C-w>z", "<cmd>WindowsMaximize<cr>", desc = "Maximize window" },
  },
  opts = {},
}
