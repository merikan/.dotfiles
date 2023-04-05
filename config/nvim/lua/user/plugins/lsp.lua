-- LSP setup
--
local M = {
  "neovim/nvim-lspconfig",                    -- config for lsp servers
  "williamboman/mason.nvim",                  -- package manager 
  "williamboman/mason-lspconfig.nvim",        -- bridges mason.nvim with the lspconfig
  "simrat39/inlay-hints.nvim",                -- support for LSP Inlay Hints
  "j-hui/fidget.nvim",                        -- standalone UI for nvim-lsp progress
  "mfussenegger/nvim-jdtls",                 -- Java LS
  "simrat39/rust-tools.nvim"

-- -- Debugging
-- use 'nvim-lua/plenary.nvim'
-- use 'mfussenegger/nvim-dap'
}

function M.config()
      require "user.lsp"
end

return M
