-- https://github.com/akinsho/bufferline.nvim
local M = {}

function M.setup()
  vim.opt.termguicolors = true

  require("bufferline").setup {
    options = {
      numbers = "none",
      separator_style = "slant",
      offsets = {
        {
          filetype = "NvimTree",
          text = "NvimTree",
          highlight = "Directory",
          text_align = "left",
        },
      },
      close_command = "Bdelete! %d", -- plugin moll/vim-bbye
      right_mouse_command = "Bdelete! %d", -- plugin moll/vim-bbye
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match "error" and " " or " "
        return " " .. icon .. count
      end,
    },
  }

  keymap("n", "<leader>q", ":Bdelete")
end

return M
