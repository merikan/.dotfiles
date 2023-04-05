-- line/block comments
-- https://github.com/numToStr/Comment.nvim

local M = { 
    "nyngwang/NeoZoom.lua",
  }


function M.config()

      require('neo-zoom').setup {
      -- top_ratio = 0,
      -- left_ratio = 0.225,
      -- width_ratio = 0.775,
      -- height_ratio = 0.925,
      -- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
      exclude_buftypes = { 'terminal' },
      }
      local NOREF_NOERR_TRUNC = { silent = true, nowait = true }
      vim.keymap.set('n', '<leader>z', require("neo-zoom").neo_zoom, NOREF_NOERR_TRUNC)
end

return M
