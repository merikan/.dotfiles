local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim"},
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
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
      layout_config = {
        horizontal = {
          -- prompt_position = "top",
          preview_width = 0.55,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      mappings = {
        i = {
          ["<Down>"] = actions.cycle_history_next,
          ["<Up>"]   = actions.cycle_history_prev,
          ["<C-n>"]  = actions.cycle_history_next,
          ["<C-p>"]  = actions.cycle_history_prev,
          ["<C-j>"]  = actions.move_selection_next,
          ["<C-k>"]  = actions.move_selection_previous,
        },
      },
    },
  }
  -- load_extension, somewhere after setup function
  -- fzf-native is a c port of fzf.
  telescope.load_extension("fzf")
  -- grep with arguments and ripgrep
  -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
  telescope.load_extension("live_grep_args")
  -- file browser extension for telescope
  telescope.load_extension("file_browser")
  -- Telescope Notification history review and finder
  telescope.load_extension("notify")
  -- switch between projects
  telescope.load_extension('project')
end

return M
