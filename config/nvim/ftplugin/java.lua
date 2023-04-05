-- https://github.com/mfussenegger/nvim-jdtls

local jdtls = prequire "jdtls"
if not jdtls then
  vim.notify "JDTLS not found, install with `:MasonInstall jdtls`"
  return
end

local root_markers = { ".git", "mvnw", "gradlew" }
local root_dir = jdtls.setup.find_root(root_markers)
if root_dir == "" then
  vim.notify  "nvim-jtls: no root_dir found."
  return
end

local util = require "lspconfig.util"
local jdtls_package_dir = require("mason-registry").get_package("jdtls"):get_install_path()
local jdtls_bin = util.path.join(jdtls_package_dir, "bin", "jdtls") -- wrapper script

local share_dir = vim.env.XDG_SHARE_HOME or util.path.join(vim.env.HOME, ".local/share")
local cache_dir = vim.env.XDG_CACHE_HOME or util.path.join(vim.env.HOME, ".cache")

local jdtls_cache_dir = util.path.join(cache_dir, "jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = util.path.join(jdtls_cache_dir, "workspace", project_name)
local lombok_jar = util.path.join(jdtls_package_dir, "lombok.jar")

-- bundles for debugging etc provided by mason package 'java-test'
local bundles = {} 
local java_test_pkg = require("mason-registry").get_package("java-test")
if java_test_pkg:is_installed() then
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_pkg:get_install_path() .. "extension/server/*.jar"), "\n"))
  --vim.notify(bundles)
end
local java_debug_pkg = require("mason-registry").get_package("java-debug-adapter")
if java_debug_pkg:is_installed() then
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_debug_pkg:get_install_path() .. "extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n"))
  --vim.notify(bundles)
end
-- extended capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- java configuration
local java_runtimes = {
  {
    name = "JavaSE-18",
    path = vim.env.SDKMAN_CANDIDATES_DIR .. "/java/18-tem",
  },
  {
    name = "JavaSE-17",
    path = vim.env.SDKMAN_CANDIDATES_DIR .. "/java/17.0.5-tem",
  },
  {
    name = "JavaSE-11",
    path = vim.env.SDKMAN_CANDIDATES_DIR .. "/java/11.0.13-tem",
  },
  {
    name = "JavaSE-1.8",
    path = vim.env.SDKMAN_CANDIDATES_DIR .. "/java/8.0.282.hs-adpt",
  },
}
local java_config = {
    -- jdt = {
    --   ls = {
    --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
    --   }
    -- },
    eclipse = {
      downloadSources = true,
    },
    configuration = {
      updateBuildConfiguration = "interactive",
      runtimes = java_runtimes,
    },
    maven = {
      downloadSources = true,
    },
    implementationsCodeLens = {
      enabled = true,
    },
    referencesCodeLens = {
      enabled = true,
    },
    references = {
      includeDecompiledSources = true,
    },
    inlayHints = {
      parameterNames = {
        enabled = "all", -- literals, all, none
      },
    },
    format = {
      enabled = false,
      -- settings = {
      --   profile = "asdf"
      -- }
    },
  signatureHelp = {
    enabled = true 
  },
  completion = {
    favoriteStaticMembers = {
      "org.hamcrest.MatcherAssert.assertThat",
      "org.hamcrest.Matchers.*",
      "org.hamcrest.CoreMatchers.*",
      "org.junit.jupiter.api.Assertions.*",
      "java.util.Objects.requireNonNull",
      "java.util.Objects.requireNonNullElse",
      "org.mockito.Mockito.*",
    },
  },
  contentProvider = { preferred = "fernflower" },
  extendedClientCapabilities = extendedClientCapabilities,
  sources = {
    organizeImports = {
      starThreshold = 9999,
      staticStarThreshold = 9999,
    },
  },
  codeGeneration = {
    toString = {
      template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
    },
    useBlocks = true,
  },
}



local config = {
  -- The command that starts the language server
  -- NOTICE: I am using the python wrapper
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    jdtls_bin,
    '--jvm-arg=-javaagent:' .. lombok_jar,
    '--jvm-arg=-Dlog.level=ALL',
    '-data', workspace_dir
  },
  root_dir = root_dir,
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = java_config,
  },

  -- Language server `initializationOptions`
  -- if you want to use additional eclipse.jdt.ls plugins.for debugging etc
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  init_options = {
    bundles = {}
  },
}

-- read project java settings if exists and apply to current
-- should be in root dir/.jdtls/config.lua
local project_jdtls_config = util.path.join(root_dir, ".nvim", "jdtls.lua")

local opts = prequire(project_jdtls_config)
if opts  then
  vim.notify("Jag hittade en fil i roten " .. project_jdtls_config)
  vim.notify(opts)
   --opts = vim.tbl_deep_extend("force", server_opts, opts)
else 
  vim.notify("Hittade ingen fil! " .. project_jdtls_config)
end


-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
