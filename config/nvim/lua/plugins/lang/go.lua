return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "golangci-lint" })
    end,
  },
  {
    "warpaint9299/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "go",
    },
  },
}
