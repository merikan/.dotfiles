return {
  -- lazyvim axtras lag:markdown
  -- https://www.lazyvim.org/extras/lang/markdown
  {
    import = "lazyvim.plugins.extras.lang.markdown",
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    opts = {
      preset = "lazy", -- play nicely with LazyVim
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
  --  DevDocs documentations
  --  https://github.com/luckasRanarison/nvim-devdocs
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "markdown",
    },
  },
}
