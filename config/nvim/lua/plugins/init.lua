-- this file is loaded by lazyvim and is the starting point for
-- my added plugins and overrided LazyVim plugin configs
--
-- for examples how to config https://www.lazyvim.org/configuration/examples

return {
  -- -- import any extras modules here
  -- see ../../lazyvim.json for added extras

  { import = "lazyvim.plugins.extras.coding.mini-surround" },
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.editor.outline" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.java" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.nix" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.test.core" },
  --
  { import = "plugins.coding" },
  { import = "plugins.editor" },
  { import = "plugins.lang" },
  { import = "plugins.misc" },
  { import = "plugins.ui" },
  { import = "plugins.lazyvim.util" },

}
