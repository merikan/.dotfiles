-- https://github.com/kyazdani42/nvim-tree.lua

local M = {}

function M.setup()
  -- mappings
  vim.api.nvim_set_keymap("n", "<Leader>e", ":NvimTreeToggle<CR>", { silent = true })

  local tree_cb = require("nvim-tree.config").nvim_tree_callback
  -- settings
  -- some options are still not migrated to setup{}
  -- vim.g.nvim_tree_width = 25
  -- vim.g.nvim_tree_indent_markers = 1

  require("nvim-tree").setup {
    auto_open = 1,
    auto_close = 1,
    view = {
      auto_resize = true,
      mappings = {
        custom_only = false,
        list = {
          { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
          { key = "h", cb = tree_cb "close_node" },
        },
      },
    },
    update_cwd = true,
    update_focused_file = {
      enable = true,
--      update_cwd = true,
    },
  }
end

return M
