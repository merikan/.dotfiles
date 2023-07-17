-- override/extend lazyvim default config

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- when autosave, turn off autoformat
    local autosave = prequire("plugins.auto-save")
    if autosave and autosave.enabled then
      opts.autoformat = false
    end
  end,
}
