-- lazyvim extra rest
-- https://www.lazyvim.org/extras/util/rest
return {
  {
    "mistweaverco/kulala.nvim",
    opts = {
      -- default_winbar_panes = { "body", "headers", "headers_body", "script_output" },
      -- winbar = true,
      icons = {
        inlay = {
          loading = "󰔟",
          done = " ",
          error = " ",
        },
        lualine = " ",
      },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       kulala_ls = {},
  --     },
  --   },
  -- },
  -- {
  --   "stevearc/conform.nvim",
  --   opts = function(_, opts)
  --     opts.formatters_by_ft.http = opts.formatters_by_ft.http or {}
  --     table.insert(opts.formatters_by_ft.python, "kulala")
  --     return opts
  --   end,
  -- },
}
