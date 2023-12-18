return  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        dartls = {
          mason = false, -- don't install with mason
        },
      },
    },
}
