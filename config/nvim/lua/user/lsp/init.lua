local lspconfig = prequire("lspconfig")
if not lspconfig then
	return
end

require("mason")
local registry = require "mason-registry"
local Cat = require "mason-core.package".Cat
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup {
	automatic_installation = true,
}

local lsp_servers = {}
local packages = registry.get_installed_packages()
for _, p in ipairs(packages) do
  if vim.fn.count(p.spec.categories, "LSP") > 0 then
    table.insert(lsp_servers, p.name)
  end
end

-- add LSPs not installed by Mason
lsp_servers = vim.tbl_extend("keep", lsp_servers, {"dartls"})

local mappings = mason_lspconfig.get_mappings().mason_to_lspconfig
local opts = { }
for _, server in ipairs(lsp_servers) do
  if server == 'jdtls' then goto continue end --we will configure jdtls in ftplugin
  local lsp_name = mappings[server]
  -- TODO fix this soup with mason and packages
  if not lsp_name then
    vim.notify("unable to map lsp name for mason package " .. server)
    goto continue
  end

  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  -- load server settings if exists
  local extra_opts = prequire("user.lsp.settings." .. lsp_name)
  if extra_opts then
    opts = vim.tbl_deep_extend("force", opts, extra_opts)
  end

  lspconfig[lsp_name].setup(opts)


  ::continue::
end

require("user.lsp.handlers").setup()
