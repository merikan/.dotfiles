
local prefix = "<leader>L"


return {
  -- import any extras modules here
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.test.core" },
  --
  -- import/override with your plugins
  { import = "plugins.editor" },
  { import = "plugins.ui" },
  { import = "plugins.lang" },
  { import = "plugins.misc" },
  {
    -- make our own Lazy menu
    "folke/which-key.nvim",
    opts = function(_, opts)
      local util = require("lazyvim.util")
      opts.spec = {
          { prefix, group = "Lazy Settings" },
          { prefix .."P", "<cmd>Mason<CR>",  desc = "Package Manager - [Mason]" },
          { prefix .."p", "<cmd>Lazy<CR>",  desc = "Plugin Manager - [LazyVim]" },
          { prefix .."e", "<cmd>LazyExtras<CR>",  desc = "Extras Manager - [LazyVim]" },
          { prefix .."i", "<cmd>LspInfo<CR>",  desc = "Lsp Info" },
          { prefix .."c", util.news.changelog,  desc = "Changelog [LazyVim]" },
          { prefix .."r", util.root.info,  desc = "Root Info [LazyVim]" },
          { prefix .."M", vim.cmd.messages,  desc = "Display messages" },
        }
    end,
  },
}
