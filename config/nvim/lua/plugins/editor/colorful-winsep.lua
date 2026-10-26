return {
  -- color the separators around the active window, like tmux does for panes
  -- https://github.com/nvim-zh/colorful-winsep.nvim
  "nvim-zh/colorful-winsep.nvim",
  event = { "WinLeave" },
  opts = {
    highlight = "#A7C080", -- everforest green
  },
}
