return {
  "neovim/nvim-lspconfig",
  dependencies = { "mfussenegger/nvim-jdtls" },
  opts = {
    setup = {
      jdtls = function(_, opts)
        return true  -- don't load with nvim-lspconfig
      end,
    },
  },
}

