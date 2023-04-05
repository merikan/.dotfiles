--adds indentation guides to all lines (including empty lines)
-- https://github.com/lukas-reineke/indent-blankline.nvim
--
local M = { "lukas-reineke/indent-blankline.nvim" }

function M.config()

  require("indent_blankline").setup {
    char = "▏",
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    use_treesitter = true,
    show_current_context = true,
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
      "help",
      "packer",
      "NvimTree",
    },
  }
end 

return M
