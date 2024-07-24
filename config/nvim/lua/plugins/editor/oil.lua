return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    optional = true,
  },
  opts = {
    columns = { "icon" },
    delete_to_trash = true,
    float = {
      max_height = 45,
      max_width = 90,
    },
    keymaps = {
      ["q"] = "actions.close",
      ["<C-h>"] = false,
      ["<M-h>"] = "actions.select_split",
    },
    view_options = {
      show_hidden = true,
    },
  },
  -- stylua: ignore
  keys = {
    -- Open parent directory in current window
    { "-", "<CMD>Oil<CR>", { desc = "Open Oil in parent directory" } },
    -- Open parent directory in floating window
    { "<leader>-", function() require("oil").toggle_float() end, desc = "toggle Oil in floating window" }
  },
}
