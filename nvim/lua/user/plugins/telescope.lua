-- https://github.com/nvim-telescope/telescope.nvim
local M = {}

M.setup = function()
  -- mappings
  vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>Telescope find_files<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>ft', '<cmd>Telescope<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<C-p>', ":lua require'telescope'.extensions.project.project{}<CR>", {noremap = true, silent = true})

  -- settings
  local actions = require("telescope.actions")
  require("telescope").setup {
      defaults = {
          layout_config = {
            width = 0.75,
            -- prompt_position = "top",
            preview_cutoff = 120,
            horizontal = {mirror = false},
            vertical = {mirror = false},
          },
          find_command = {'rg', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'},
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",
          file_sorter = require'telescope.sorters'.get_fuzzy_file,
          file_ignore_patterns = {},
          generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
          path_display = {},
          winblend = 0,
          border = {},
          borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
          color_devicons = true,
          use_less = true,
          set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
          file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
          grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
          qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
          buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
          mappings = {
              i = {
                  ["<C-j>"] = actions.move_selection_next,
                  ["<C-k>"] = actions.move_selection_previous,
                  ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                  ["<esc>"] = actions.close,
                  ["<CR>"] = actions.select_default + actions.center
              },
              n = {
                  ["<C-j>"] = actions.move_selection_next,
                  ["<C-k>"] = actions.move_selection_previous,
                  ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              }
          },
          pickers = {
            -- Default configuration for builtin pickers goes here:
            -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
          },
          extensions = {
            -- Your extension configuration goes here:
            project = {
              base_dirs = {
                '~/src',
              },
              hidden_files = true -- default: false
            }
          }
      }
  }

  -- load extensions
  require("telescope").load_extension('project')
end

return M
