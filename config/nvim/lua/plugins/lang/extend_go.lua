-- intelligently collapses Go error handling blocks
-- https://github.com/TheNoeTrevino/no-go.nvim
return {
  "noetrevino/no-go.nvim",
  enabled = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = "go",
  opts = {
    -- Your configuration here (optional)
    -- lazy.nvim automatically calls setup() with the opts property
    identifiers = { "err", "error" }, -- Customize which identifiers to collapse
    -- look at the default config for more details
  },
}
