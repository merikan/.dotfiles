return {
  -- lazyvim axtras lag:markdown
  -- https://www.lazyvim.org/extras/lang/markdown
  {
    "MeanderingProgrammer/markdown.nvim",
    opts = {
      preset = "lazy", -- play nicely with LazyVim
    },
    config = function()
      require('render-markdown').disable()
    end,
    keys = {
      { "<leader>uR", "<cmd>RenderMarkdown toggle<cr>", mode = { "n" }, desc = "Toggle Render Markdown" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "--" },
        },
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
  -- edit markdown tables using treesitter
  -- https://github.com/kiran94/edit-markdown-table.nvim
  {
    "kiran94/edit-markdown-table.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "EditMarkdownTable",
  },
  -- Markdown like keymaps for toggling text formatting
  -- https://github.com/antonk52/markdowny.nvim
  {
    "antonk52/markdowny.nvim",
    ft = { "markdown", "txt" },
    opts = {
      filetypes = { "markdown", "txt" },
    },
  },
  --  DevDocs documentations
  --  https://github.com/luckasRanarison/nvim-devdocs
  {
    "warpaint9299/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "markdown",
    },
  },
}
