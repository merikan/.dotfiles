return {
  {
    -- plugin for previewing native LSP's goto definition, type definition, implementation, declaration and references calls in floating windows.
    -- https://github.com/rmagatti/goto-preview
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup {}
    end,
  },
  {
    -- one plugin to accomodate many different filetypes
    "sheerun/vim-polyglot",
    lazy = false,
    init = function()
      -- turn off sensible as I don't agree with it - https://github.com/sheerun/vim-polyglot/tree/master#default-settings
      vim.g.polyglot_disabled = { "sensible" }
    end,
  },
}