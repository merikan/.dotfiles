return {
  -- DevDocs documentations in neovim
  {
    ---@deprecated
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
      },
    },
  },
}
