return {
  { import = "lazyvim.plugins.extras.editor.telescope" },
  -- A telescope extension to view and search your undo tree
  -- https://github.com/debugloop/telescope-undo.nvim
  {
    "nvim-telescope/telescope.nvim",
    -- stylua: ignore
    opts = {
      defaults = {
        path_display = {
          filename_first = {
            reverse_directories = true,
          },
        },
      },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    opts = {},
    config = function()
      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").setup {
          extensions = {
            undo = {
              use_delta = true,
              side_by_side = true,
              layout_strategy = "vertical",
              layout_config = {
                preview_height = 0.6,
              },
            },
          },
        }
        require("telescope").load_extension("undo")
      end)
    end,
    keys = {
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undos" },
    },
  },
  -- A telescope extension to handle lazy plugins
  -- https://github.com/tsakirist/telescope-lazy.nvim
  {
    "tsakirist/telescope-lazy.nvim",
    config = function()
      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").load_extension("lazy")
      end)
    end,
    keys = {
      { "<leader>sp", "<cmd>Telescope lazy<CR>", desc = "Plugins (Lazy)" },
    },
  },
  -- A telescope extension to add import statement
  -- https://github.com/piersolenski/telescope-import.nvim
  {
    "piersolenski/telescope-import.nvim",
    opts = {},
    config = function()
      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").setup {
          extensions = {
            import = {
              insert_at_top = true,
            },
          },
        }
        require("telescope").load_extension("import")
      end)
    end,
    keys = {
      { "<leader>sI", "<cmd>Telescope import<CR>", desc = "Imports" },
    },
  },
}
