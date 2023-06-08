-- A code outline window for skimming and quick navigation
-- https://github.com/stevearc/aerial.nvim

local M = { "stevearc/aerial.nvim" }

M.config = function()

  require('aerial').setup({
    attach_mode = "global",
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
    end
  })
  vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
end

return M
