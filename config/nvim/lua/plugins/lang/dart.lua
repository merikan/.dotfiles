return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dartls = {
          mason = false, -- don't install with mason
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "dart",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dart-debug-adapter" })
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "sidlatau/neotest-dart",
    },
    opts = {
      adapters = {
        ["neotest-dart"] = {},
      },
    },
  },
  --  DevDocs documentations
  --  https://github.com/luckasRanarison/nvim-devdocs
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "dart-2",
    },
  },
}
