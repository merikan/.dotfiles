-- *.kdl is not detect
-- see https://github.com/neovim/neovim/issues/23522
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.kdl",
  command = "setfiletype kdl",
})