local prefix = "<leader>gp"
return {
  -- plugin for previewing native LSP's goto definition, type definition, implementation, declaration and references calls in floating windows.
  -- https://github.com/rmagatti/goto-preview
  {
    "rmagatti/goto-preview",
    keys = {
      -- stylua: ignore start
      { prefix .. "d", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", desc = "Preview Definition" },
      { prefix .. "y", "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>", desc = "Preview T[y]pe Definition", },
      { prefix .. "i", "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", desc = "Preview Implementation", },
      { prefix .. "D", "<cmd>lua require('goto-preview').goto_preview_declaration()<cr>", desc = "Preview Declaration" },
      { prefix .. "c", "<cmd>lua require('goto-preview').close_all_win()<cr>", desc = "Close All Preview Win" },
      { prefix .. "r", "<cmd>lua require('goto-preview').goto_preview_references()<cr>", desc = "Preview References" },
      -- stylua: ignore end
    },
  },
  -- add menu
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "goto-preview", icon = "🔍 " },
      },
    },
  },
  {
    -- one plugin to accomodate many different filetypes
    "sheerun/vim-polyglot",
    enabled = true,
    lazy = false,
    init = function()
      -- turn off sensible as I don't agree with it - https://github.com/sheerun/vim-polyglot/tree/master#default-settings
      -- turn off ftdetect since it interferes with neovim's ftdetect
      vim.g.polyglot_disabled = { "sensible", "ftdetect" }
    end,
  },
}
