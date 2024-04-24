return {
  "gbprod/substitute.nvim",
  enabled= false,
  keys = {
    { mode = "n", "gr", "<cmd>lua require('substitute').operator()<cr>", desc = "substitute" },
    { mode = "n", "grr", "<cmd>lua require('substitute').line()<cr>", desc = "substitute-line" },
    { mode = "n", "gR", "<cmd>lua require('substitute').eol()<cr>", desc = "substitute-eol" },
    { mode = "x", "gr", "<cmd>lua require('substitute').visual()<cr>", desc = "substitute" },
  },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
