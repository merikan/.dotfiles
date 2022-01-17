-- https://github.com/lewis6991/gitsigns.nvim
local M = {}

M.setup = function()
  ---@diagnostic disable-next-line: redundant-parameter
  require("gitsigns").setup {}

  vim.cmd [[ command! GitsignsToogle  lua require"gitsigns.actions".toggle_signs() ]]
end

return M
