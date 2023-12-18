-- previewer for LSP code actions
-- https://github.com/aznhe21/actions-preview.nvim
return {
  "aznhe21/actions-preview.nvim",
  lazy = true,
  keys = {
    {
      "<localleader>ca",
      function()
        require("actions-preview").code_actions()
      end,
      desc = "lsp: code actions with preview",
      mode = { "n", "v" },
    },
  },
  config = function()
    require("actions-preview").setup {
      -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
      diff = {
        ctxlen = 3,
        algorithm = "patience",
        ignore_whitespace = true,
      },
      backend = { "telescope", "nui" },
      -- options for telescope.nvim: https://github.com/nvim-telescope/telescope.nvim#themes
      telescope = require("telescope.themes").get_dropdown(),
    }
  end,
}
