return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    optional = true,
  },
  opts = {
    columns = {
      "icon",
      --   "permissions",
      --   "size",
      -- "mtime",
    },
    delete_to_trash = true,
    float = {
      max_height = 45,
      max_width = 90,
    },
    keymaps = {
      ["q"] = "actions.close",
      -- Make split mappings consistent with Telescope.
      ["<C-h>"] = false,
      ["<C-s>"] = false,
      ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
      ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
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
