-- A portable package manager to install and manage LSP servers, DAP servers, linters, and formatters.
-- https://github.com/williamboman/mason.nvim

local M = {
    "williamboman/mason.nvim",
    build = ":MasonUpdate" -- :MasonUpdate updates registry contents
}
-- https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md
M.packages = {
  "bash-language-server",
  "beautysh",
  "black",
  "cmake-language-server",
  "codelldb",
  "css-lsp",
  "dart-debug-adapter",
  "deno",
  "diagnostic-languageserver",
  "dockerfile-language-server",
  "emmet-ls",
  "eslint-lsp",
  "eslint_d",
  "flake8",
  "go-debug-adapter",
  "goimports",
  "golangci-lint",
  "gopls",
  "gotests",
  "gotestsum",
  "gradle-language-server",
  "graphql-language-service-cli",
  "groovy-language-server",
  "hadolint",
  "html-lsp",
  "isort",
  "java-debug-adapter",
  "java-test",
  "jdtls",
  "jq",
  "json-lsp",
  "kotlin-debug-adapter",
  "kotlin-language-server",
  "ktlint",
  "lemminx",
  "lua-language-server",
  "lua-language-server",
  "luacheck",
  "luaformatter",
  "marksman",
  "prettierd",
  "python-lsp-server",
  "rust-analyzer",
  "rustfmt",
  "selene",
  "shellcheck",
  "shfmt",
  "sql-formatter",
  "sqlls",
  "stylua",
  "svelte-language-server",
  "tailwindcss-language-server",
  "taplo",
  "terraform-ls",
  "typescript-language-server",
  "vue-language-server",
  "yaml-language-server",
  "yamlfmt",
  "yamllint",
  -- "semgrep",
}

local install = function()
  local registry = require "mason-registry"
  for _, p in ipairs(M.packages) do
    local pkg = registry.get_package(p)
    if not pkg:is_installed() then
      vim.notify("[mason] installing " .. p)
      pkg:install()
    end
  end
end

M.config = function()
  require("mason").setup()
  install()
end

return M
