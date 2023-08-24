local M = {}

M.setup = function()
  vim.o.termguicolors = true
  vim.cmd [[
    hi CursorLine guibg=#303000 ctermbg=234
    hi DiffAdd guibg=#6A8759 ctermbg=101
    hi DiffChange guibg=#FFC66D ctermbg=216
    hi DiffDelete guibg=#9e2927 ctermbg=124
  ]]
end

return M
