return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "biome",
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- biome understands comments and trailing commas, unlike jsonlint
        json = { "biomejs" },
        jsonc = { "biomejs" },
      },
    },
  },
}
