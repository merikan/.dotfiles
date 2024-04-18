-- Bookmark your files, separated by project, and quickly navigate through them.
-- https://github.com/otavioschwanck/arrow.nvim
return {
  {
    "otavioschwanck/arrow.nvim",
    event = "VeryLazy",
    opts = {
      show_icons = true,
      hide_handbook = false, -- set to true to hide the shortcuts on menu.
      mappings = {
        toggle = "a", -- this is 'add' aka 'save'
        remove = "x",
        edit = "e",
        delete_mode = "D",
        clear_all_items = "X",
        open_vertical = "s",
        open_horizontal = "-",
        quit = "q",
      },
      leader_key = ";",
      separate_save_and_remove = true,
    },
    keys = {
     -- stylua: ignore
      { "<C-e>", function() require("arrow.ui").openMenu() end, desc = "Arrow menu", },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_y, require("arrow.statusline").text_for_statusline_with_icons())
    end,
  },
}
