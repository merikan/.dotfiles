vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.templ",
  command = "setfiletype templ",
})