-- https://github.com/folke/trouble.nvim
local M = {}

local set_keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

M.setup = function()

  set_keymap('n', '<Leader>tt', '<Cmd>TroubleToggle<CR>', opts)

  require("trouble").setup {
    -- see default config at https://github.com/folke/trouble.nvim#setup
    mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    action_keys = { -- key mappings for actions in the trouble list
      toggle_mode = "t", -- toggle between "workspace" and "document" diagnostics mode
    }
  }

end

return M
