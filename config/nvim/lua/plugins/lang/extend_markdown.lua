-- lazyvim extras lang:markdown
-- https://www.lazyvim.org/extras/lang/markdown

local XDG_CONFIG_DIR = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = {
            "--config",
            XDG_CONFIG_DIR .. "/markdownlint/.markdownlint.yaml",
            "--",
          },
        },
      },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    ft = { "markdown", "norg", "rmd", "org", "codecompanion", "latex", "typst" },
    opts = {
      preview = {
        enable = false,
        icon_provider = "mini",
      },
      code_blocks = {
        sign = false,
      },
    },
    keys = {
      { "<leader>um", "<cmd>Markview Toggle<cr>", desc = "Toggle Markview" },
      { "<leader>uM", "<cmd>Markview splitToggle<cr>", desc = "Toggle Markview splitview" },
    },
  },
  {
    {
      "brianhuster/live-preview.nvim",
      dependencies = {
        -- You can choose one of the following pickers
        -- 'nvim-telescope/telescope.nvim',
        -- 'ibhagwan/fzf-lua',
        -- 'echasnovski/mini.pick',
        "folke/snacks.nvim",
      },
      keys = function(plugin)
        return {
          {
            "<leader>cP",
            function()
              if require("livepreview").is_running() then
                vim.cmd.LivePreview("close")
              else
                vim.cmd.LivePreview("start")
              end
            end,
            ft = "markdown",
            desc = "Toggle live preview",
          },
        }
      end,
    },
    -- a markdown table editor
    -- https://github.com/SCJangra/table-nvim
    {
      "SCJangra/table-nvim",
      ft = "markdown",
      opts = {},
    },
    -- Markdown-based Neovim todo plugin
    -- https://github.com/bngarren/checkmate.nvim
    {
      "bngarren/checkmate.nvim",
      ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
      opts = {
        files = { "*.md" },
        todo_states = {
          unchecked = {
            marker = "[ ]",
          },
          checked = {
            marker = "[x]",
          },
        },
      },
    },
    -- add group
    {
      "folke/which-key.nvim",
      opts = {
        spec = {
          { "<leader>T", group = "todo" },
        },
      },
    },
    --  Visualize your Markdown as mindmaps with markmap
    --  https://github.com/Zeioth/markmap.nvim
    {
      "Zeioth/markmap.nvim",
      build = "yarn global add markmap-cli",
      cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
      opts = {
        html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
        hide_toolbar = false, -- (default)
        grace_period = 3600000, -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
      },
      config = function(_, opts)
        require("markmap").setup(opts)
      end,
    },
    -- ------- disabled -------------------------

    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    {
      "MeanderingProgrammer/render-markdown.nvim",
      enabled = false,
      opts = {
        -- Disable automatic rendering on normal buffers so touchup.nvim operates freely
        -- enabled = false,
        file_types = {},
      },
      keys = {
        { "<leader>mp", ft = "markdown", "<cmd>RenderMarkdown preview<cr>", desc = "Markdown Preview (side by side)" },
      },
    },

    -- Non-intrusive markdown render/decorater
    -- https://github.com/noisesfromspace/touchup.nvim
    -- disabled: since I am using OXY2DEV/markview.nvim
    {
      "noisesfromspace/touchup.nvim",
      enabled = false,
      ft = { "markdown" },
      opts = {},
    },

    {
      -- https://github.com/MeanderingProgrammer/render-markdown.nvim
      "MeanderingProgrammer/render-markdown.nvim",
      enabled = false,
      opts = {
        enabled = false,
      },
      keys = {
        {
          "<leader>cp",
          ft = "markdown",
          "<cmd>RenderMarkdown preview<cr>",
          desc = "Markdown Preview (side by side)",
        },
      },
    },
    {
      "iamcco/markdown-preview.nvim",
      enabled = false,
      keys = {
        -- { "<leader>cp", false },
        { "<leader>cP", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview (in browser)" },
      },
    },
  },
}
