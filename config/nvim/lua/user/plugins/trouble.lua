-- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists
-- https://github.com/folke/trouble.nvim
local M = {
   "folke/trouble.nvim",
      dependencies = "nvim-tree/nvim-web-devicons"
}

M.setup = function()

  require("trouble").setup {
    -- see default config at https://github.com/folke/trouble.nvim#setup
    mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    action_keys = { -- key mappings for actions in the trouble list
      toggle_mode = "t", -- toggle between "workspace" and "document" diagnostics mode
    }
  }

end

return M
