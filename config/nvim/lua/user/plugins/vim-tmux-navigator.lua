-- make tmux and and nvim work together
-- https://github.com/alexghergh/nvim-tmux-navigation

local M = { "alexghergh/nvim-tmux-navigation" }

function M.config()
  require("nvim-tmux-navigation").setup {
    disable_when_zoomed = true, -- defaults to false
    keybindings = { -- remap to remove C-space
      left  = "<C-h>",
      down  = "<C-j>",
      up    = "<C-k>",
      right = "<C-l>",
    }
  }
end

return M
