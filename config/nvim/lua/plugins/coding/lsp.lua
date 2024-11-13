return {
  {
    "nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false, -- using tiny-inline-diagnostic
      },
    },
  },
  {
    -- plugin for previewing native LSP's goto definition, type definition, implementation, declaration and references calls in floating windows.
    -- https://github.com/rmagatti/goto-preview
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup {}
    end,
  },
  -- Display LSP inlay hints at the end of the line
  -- https://github.com/chrisgrieser/nvim-lsp-endhints
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {
      icons = {
        type = "󰜁 ",
        parameter = "󰏪 ",
        offspec = " ", -- hint kind not defined in official LSP spec
        unknown = " ", -- hint kind is nil
      },
      label = {
        padding = 1,
        marginLeft = 0,
        bracketedParameters = true,
      },
      autoEnableHints = true,
    },
    config = function(_, opts)
      require("lsp-endhints").setup(opts)
    end,
  },
}
