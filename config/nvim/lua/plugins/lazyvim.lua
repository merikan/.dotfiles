return {
  -- import any extras modules here
  { import = "lazyvim.plugins.extras.editor.aerial" },
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.test.core" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.rust" },
-- import/override with your plugins
  { import = "plugins.editor" },
  { import = "plugins.ui" },
  { import = "plugins.lang" },
  { import = "plugins.other" },

  -- lazyvim options
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  }, -- { import = "lazyvim.plugins.extras.ui.edgy" },
}
