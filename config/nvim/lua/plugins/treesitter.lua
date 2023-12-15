-- override/extend lazyvim default config
-- https://www.lazyvim.org/plugins/treesitter#nvim-treesitter

-- add more treesitter parsers
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
vim.filetype.add {
  extension = {
    templ = "templ",
  },
}

return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "dart",
      "html",
      "java",
      "javascript",
      "json",
      "kdl",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "templ",
      "vim",
      "vimdoc",
      "yaml",
    },
  },
}
