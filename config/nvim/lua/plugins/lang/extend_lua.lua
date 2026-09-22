return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "hs", "spoon" },
            },
          },
        },
      },
    },
  },
}
