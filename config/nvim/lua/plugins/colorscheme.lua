return {
  -- add schemes
  { "doums/darcula", event = "VeryLazy" },
  -- { "aaronkollasch/darcula", event = "VeryLazy" },
  { "RRethy/nvim-base16", event = "VeryLazy" },
  { "gruvbox-community/gruvbox", event = "VeryLazy" },
  { "folke/tokyonight.nvim", event = "VeryLazy" },
  { "lunarvim/darkplus.nvim", event = "VeryLazy" },
  { "sainnhe/gruvbox-material", event = "VeryLazy" },
  { "joshdick/onedark.vim", event = "VeryLazy" },
  { "kvrohit/rasmus.nvim", event = "VeryLazy" },
  { "catppuccin/nvim", name = "catppuccin", event = "VeryLazy"},

  -- load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "darcula",
    },
  }
}
