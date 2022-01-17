-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local M = {}

local lsp_installer = require "nvim-lsp-installer"
local lsp_servers = require "nvim-lsp-installer.servers"

-- my preferred servers (https://github.com/williamboman/nvim-lsp-installer#available-lsps)
local preferred_servers = {
  "ansiblels",
  "angularls",
  "bashls",
  "cmake",
  'cssls',
  "dartls",
  "diagnosticls",
  "dockerls",
  "eslint",
  "emmet_ls",
  "gopls",
  "graphql",
  "groovyls",
  'html',
  "jsonls",
  "jdtls",
  "kotlin_language_server",
  'sumneko_lua',
  "rust_analyzer",
  "svelte",
  "tailwindcss",
  "taplo",
  'tsserver',
  'pylsp',
  'volar',
  "lemminx",
  "yamlls",
}


local function update_all_servers()
  for _, server in ipairs(lsp_servers.get_installed_servers()) do
        -- lsp_installer.install(server)
        server:install()
  end
end
-- add vim command :LspUpdateAllServers, also available as U in info window
-- make it global for now > https://github.com/neovim/neovim/issues/13862
_G.lsp_update_all_servers = update_all_servers
vim.cmd 'command! LspUpdateAllServers call v:lua.lsp_update_all_servers()'
-- vim.cmd 'command! LspUpdateAllServers call v:lua.require('user.lsp').update_all_servers()'

local function install_preferred_servers(show_window)
  if (show_window) then lsp_installer.info_window.open() end
  for _, preferred_server in ipairs(preferred_servers) do
    local ok, server = lsp_installer.get_server(preferred_server)
    if ok and not server:is_installed() then
        server:install()
    end
  end
end
-- add vim command :LspInstallPreferredServers
-- make it global for now > https://github.com/neovim/neovim/issues/13862
_G.lsp_install_preferred_servers = install_preferred_servers
vim.cmd 'command! LspInstallPreferredServers call v:lua.lsp_install_preferred_servers( "true" )'
-- vim.cmd 'command! LspInstallPreferredServers call v:lua.require('user.lsp').install_preferred_servers( "true" )'

M.setup = function()
    lsp_installer.settings {
      log_level = vim.log.levels.DEBUG,
    }

    require"user.lsp.settings".setup()

    lsp_installer.on_server_ready(function(server)
      local opts = {
        on_attach = require("user.lsp.settings").on_attach,
        capabilities = require("user.lsp.settings").capabilities,
      }

      local server_opts = prequire("user.lsp.server." .. server.name)
      if server_opts  then
         opts = vim.tbl_deep_extend("force", server_opts, opts)
      end

      server:setup(opts)

    end)

    install_preferred_servers()

end

return M
