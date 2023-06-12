-- override/extend lazyvim default config

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- when autosave, turn off autoformat
    opts.autoformat = false
  end,
}
