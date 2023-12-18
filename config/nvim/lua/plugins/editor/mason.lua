-- override/extend lazyvim default config

-- https://mason-registry.dev/registry/list
local preferred_packages = {
  lsp = {
    "ansible-language-server",
    "bash-language-server",
    "cmake-language-server",
    "css-lsp",
    "cucumber-language-server",
    "deno",
    "diagnostic-languageserver",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "drools-lsp",
    "emmet-ls",
    "eslint-lsp",
    "gopls",
    "gradle-language-server",
    "graphql-language-service-cli",
    "groovy-language-server",
    "html-lsp",
    "htmx-lsp",
    "jdtls",
    "json-lsp",
    "kotlin-language-server",
    "lemminx",
    "lua-language-server",
    "marksman",
    "nil",
    "python-lsp-server",
    "rust-analyzer",
    "sqlls",
    "svelte-language-server",
    "tailwindcss-language-server",
    "taplo",
    "templ",
    "terraform-ls",
    "typescript-language-server",
    "vue-language-server",
    "yaml-language-server",
    },
    dap = {
    "codelldb",
    "dart-debug-adapter",
    "go-debug-adapter",
    "java-debug-adapter",
    "java-test",
    "kotlin-debug-adapter",
    },
    linter = {
    "ansible-lint",
    "checkstyle",
    "eslint_d",
    "flake8",
    "gitleaks",
    "golangci-lint",
    "hadolint",
    "ktlint",
    "luacheck",
    "selene",
    "semgrep",
    "shellcheck",
    "snyk",
    "trivy",
    "yamllint",
  },
  formatter = {
    "beautysh",
    "black",
    "goimports",
    "google-java-format",
    "gotests",
    "isort",
    "jq",
    "ktlint",
    "luaformatter",
    "prettierd",
    "shfmt",
    "sql-formatter",
    "stylua",
    "yamlfmt",
  },
  other = {
    "gotestsum",
  },
}

local install_list = {}
for k, v in pairs(preferred_packages) do
  vim.list_extend(install_list, v)
end

return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = install_list,
  },
}
