local XDG_CONFIG_DIR = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"

return {
  -- lazyvim axtras lang:markdown
  -- https://www.lazyvim.org/extras/lang/markdown
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            XDG_CONFIG_DIR .. "/markdownlint/.markdownlint.yaml",
            "--",
          },
        },
      },
    },
  },
  {
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
}
