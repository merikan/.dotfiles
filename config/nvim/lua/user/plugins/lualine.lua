-- https://github.com/nvim-lualine/lualine.nvim
-- https://github.com/arkav/lualine-lsp-progress
local M = {}

local function window()
  return vim.api.nvim_win_get_number(0)
end

M.setup = function()

  require("lualine").setup {
    sections = {
      lualine_a = { window, 'mode' },
      lualine_b = {'branch', 'diff', 'diagnostics', 'lsp_progress',},
    }
  }

end

return M
