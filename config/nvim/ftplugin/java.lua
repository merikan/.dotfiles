-- https://github.com/mfussenegger/nvim-jdtls

local root_markers = { ".git", "mvnw", "gradlew" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  print "no root_dir found"
  return
end

local nvim_local_dir = vim.fn.expand('~/.local/share/nvim')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = nvim_local_dir .. '/jdtls-workspaces/' .. project_name


if vim.fn.has "mac" == 1 then
  CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
  CONFIG = "linux"
else
  print "Unsupported system"
end

local config = {
  cmd = {

    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', nvim_local_dir .. '/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
    '-configuration', nvim_local_dir .. '/lsp_servers/jdtls/config_' .. CONFIG,
    '-data', workspace_dir
  },
  root_dir = root_dir,
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
