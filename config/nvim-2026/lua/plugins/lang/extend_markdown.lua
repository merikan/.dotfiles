local XDG_CONFIG_DIR = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"

return {
  -- lazyvim extras lang:markdown
  -- https://www.lazyvim.org/extras/lang/markdown
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
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- enabled = false,
    },
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>RenderMarkdown preview<cr>", desc = "Markdown Preview (side by side)" },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    keys = {
      -- { "<leader>cp", false },
      { "<leader>cP", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview (in browser)" },
    },
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
}
