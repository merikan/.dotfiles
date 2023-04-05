local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "rcarriga/nvim-notify" }, -- notify extension
  },
}

function M.config()
  local ui = require("user.core.ui")
  local telescope = require("telescope")
  local builtin = require("telescope.builtin")
  local actions = require "telescope.actions"
  telescope.setup {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      file_ignore_patterns = { ".git/", "node_modules" },
      find_command = { "rg", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },

      mappings = {
        i = {
          ["<Down>"] = actions.cycle_history_next,
          ["<Up>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
    },
  }
  -- load_extension, somewhere after setup function
  -- fzf-native is a c port of fzf.
  telescope.load_extension("fzf")
  -- file browser extension for telescope
  telescope.load_extension("file_browser")
  -- Telescope Notification history review and finder
  telescope.load_extension("notify")
  -- switch between projects
  telescope.load_extension('project')
end

return M
