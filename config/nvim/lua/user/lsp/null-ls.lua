local M = {}

M.setup = function()
  local null_ls = require "null-ls"

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics

---@diagnostic disable-next-line: redundant-parameter
  null_ls.setup {
    debug = false,
    sources = {
      formatting.prettier.with { extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } },
      formatting.black.with { extra_args = { "--fast" } },
      formatting.stylua,
      null_ls.builtins.code_actions.gitsigns,
      -- diagnostics.flake8
    },
  }
end

return M
