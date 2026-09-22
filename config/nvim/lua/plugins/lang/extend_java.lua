return {
  -- must of the things are wired up with Java Extra
  -- https://www.lazyvim.org/extras/lang/java
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "google-java-format",
        "checkstyle",
      })
    end,
  },
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       -- java = { "google-java-format" },
  --     },
  --   },
  -- },
  -- {
  --   "mfussenegger/nvim-lint",
  --   opts = {
  --     linters_by_ft = {
  --       -- java = { "checkstyle" },
  --     },
  --   },
  -- },
}
