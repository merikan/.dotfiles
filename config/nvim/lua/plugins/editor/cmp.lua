-- A completion plugin for neovim
-- https://github.com/hrsh7th/nvim-cmp
return {
  {
    "hrsh7th/nvim-cmp",
    opts = {
      view = {
        entries = {
          follow_cursor = true,
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  {
    "tzachar/cmp-ai",
    enabled = false,
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local cmp_ai = require("cmp_ai.config")

      cmp_ai:setup {
        max_lines = 1000,
        notify = false,
        notify_callback = function(msg)
          vim.notify(msg)
        end,
        run_on_every_keystroke = true,
        ignored_file_types = {
          TelescopePrompt = true,
        },
        -- provider = ollama
        provider = "Ollama",
        provider_options = {
          model = "codellama:7b-code",
        },
      }
    end,
  },
}
