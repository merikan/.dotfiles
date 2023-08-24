-- override/extend lazyvim default config

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.autoformat = false -- turn off autoformat
  end,
}
