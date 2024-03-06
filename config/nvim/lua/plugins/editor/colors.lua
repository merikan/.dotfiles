return {
  {
    "brenoprata10/nvim-highlight-colors",
    enabled = false,
    opts = {
      render = "background", -- background | foreground | virtual
      enable_named_colors = true,
      enable_tailwind = false,
    },
  },
  {
    -- Color picker and highlighter plugin for Neovim.
    -- https://github.com/uga-rosa/ccc.nvim/tree/main
    "uga-rosa/ccc.nvim",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "css", "scss", "sh" },
    cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
    keys = {
      { "<leader>up", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Paint/Colorizer" },
      { "<A-C>", "<cmd>CccConvert<cr>", desc = "Convert color" },
      { "<S-c>", "<cmd>CccPick<cr>", desc = "Pick Color" },
    },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
  },
}
