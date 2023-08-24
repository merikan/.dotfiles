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

local lsp_servers = mason_lspconfig.get_installed_servers()  -- installed LSP lsps supported by lspconfig
-- add LSPs not installed with Mason
lsp_servers = vim.tbl_extend("keep", lsp_servers, {"dartls"})

-- local mappings = mason_lspconfig.get_mappings().mason_to_lspconfig
local opts = { }
for _, lsp in ipairs(lsp_servers) do
  -- vim.notify("Found LSP server '" .. lsp .. "' ")
  if lsp == 'jdtls' then goto continue end --we will configure jdtls in ftplugin

  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  -- load lsp settings if exists
  local extra_opts = prequire("user.lsp.settings." .. lsp)
  if extra_opts then
    opts = vim.tbl_deep_extend("force", opts, extra_opts)
  end

  lspconfig[lsp].setup(opts)

  ::continue::
end

require("user.lsp.handlers").setup()
