-- https://github.com/mfussenegger/nvim-jdtls

local jdtls = prequire("jdtls")
if not jdtls then
  vim.notify("nvim-jdtls not found, install with your package manager")
  return
end

local root_markers = { ".git", "mvnw", "gradlew" }
local root_dir = jdtls.setup.find_root(root_markers)
if root_dir == "" then
  vim.notify("nvim-jtls: no root_dir found.")
  return
end

local util = require("lspconfig.util")
local jdtls_package_dir = require("mason-registry").get_package("jdtls"):get_install_path()
local jdtls_bin = util.path.join(jdtls_package_dir, "bin", "jdtls") -- wrapper script

local data_dir = vim.env.XDG_DATA_HOME or util.path.join(vim.env.HOME, ".local/share")
local cache_dir = vim.env.XDG_CACHE_HOME or util.path.join(vim.env.HOME, ".cache")

local jdtls_cache_dir = util.path.join(cache_dir, "jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = util.path.join(jdtls_cache_dir, "workspace", project_name)
--  work-around for 'lombok.eclipse.handlers.HandleBuilder failed'
--  https://github.com/projectlombok/lombok/issues/3648
--  download lombok-edge from https://projectlombok.org/download-edge and use it in JDTLS settings
--  mkdir -p $XDG_DATA_HOME/lombok-1.18.33
--  curl -Lo $XDG_DATA_HOME/lombok-1.18.33/lombok-edge.jar https://projectlombok.org/lombok-edge.jar
local lombok_jar = util.path.join(data_dir,"lombok-1.18.33", "lombok-edge.jar")
-- local lombok_jar = util.path.join(jdtls_package_dir, "lombok.jar")

-- bundles for debugging etc provided by mason package 'java-test'
local bundles = {}
local java_test_pkg = require("mason-registry").get_package("java-test")
if java_test_pkg:is_installed() then
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_pkg:get_install_path() .. "extension/server/*.jar"), "\n"))
  --vim.notify(bundles)
end
local java_debug_pkg = require("mason-registry").get_package("java-debug-adapter")
if java_debug_pkg:is_installed() then
  vim.list_extend(
    bundles,
    vim.split(
      vim.fn.glob(java_debug_pkg:get_install_path() .. "extension/server/com.microsoft.java.debug.plugin-*.jar"),
      "\n"
    )
  )
  --vim.notify(bundles)
end
-- extended capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- java runtimes (sdkman)
local java_runtimes = {}
local java_runtimes_path = vim.env.SDKMAN_CANDIDATES_DIR .. "/java"
for runtime_dir, type in vim.fs.dir(java_runtimes_path) do
  if type == "directory" then
    -- vim.notify("Java directory '" .. runtime_dir .. "' ")
    vim.list_extend(java_runtimes, { name = runtime_dir, path = java_runtimes_path .. runtime_dir })
  end
end

-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
-- for a list of options
local settings = {
  java = {
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
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- And search for `interface RuntimeOption`
      -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
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
      enabled = true,
      -- settings = {
      --   profile = "asdf"
      -- }
    },
    signatureHelp = {
      enabled = true,
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
  },
}

local config = {
  -- The command that starts the language server
  -- NOTICE: I am using the python wrapper
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    jdtls_bin,
    "--jvm-arg=-javaagent:" .. lombok_jar,
    "--jvm-arg=-Dlog.level=ALL",
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  settings = settings,

  -- Language server `initializationOptions`
  -- if you want to use additional eclipse.jdt.ls plugins.for debugging etc
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  init_options = {
    bundles = {},
  },
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)
