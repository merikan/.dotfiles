local M = {}

M.setup = function()
  keymap("n", "<leader>q", ":Bdelete<CR>") -- close buffert
  keymap("n", "<leader>Q", ":bufdo :Bdelete<CR>") -- close all buffers
  keymap("n", "<leader>q!", ":Bdelete!<CR>") -- forse close buffert without saving
  keymap("n", "<leader>Q!", ":bufdo :Bdelete!<CR>") -- forse close all buffers without saving
end

return M
