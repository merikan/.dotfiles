return {
  desc = "Sonarlint",
  {
    "mason.nvim",
    ft = { "python", "java", "c", "cpp" },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "sonarlint-language-server" })
    end,
  },
  {
    "schrieveslaach/sonarlint.nvim",
    url = "https://gitlab.com/schrieveslaach/sonarlint.nvim.git",
    lazy = true,
    ft = {
      "java",
      "go",
      "html",
      "xml",
      "js",
      "docker",
      "yaml",
    },
    opts = {
      server = {
        cmd = {
          "sonarlint-language-server",
          "-stdio",
          "-analyzers",
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarxml.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonariac.jar"), -- docker, k8s, terraform
        },
        settings = {
          sonarlint = {
            test = "test",
          },
        },
      },
      filetypes = {
        "java",
        "go",
        "python",
        "html",
        "xml",
        "js",
        "docker",
        "yaml",
      },
    },
  },
}
