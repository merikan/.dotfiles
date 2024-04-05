-- A completion plugin for neovim
-- https://github.com/hrsh7th/nvim-cmp
return {
  {
    "hrsh7th/nvim-cmp",
    opts = {
      view = {
        entries = {
          follow_cursor = true,
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
