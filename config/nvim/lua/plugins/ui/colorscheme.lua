return {
  { "ellisonleao/gruvbox.nvim" },
  { "doums/darcula" },
  -- { "aaronkollasch/darcula" },
  { "RRethy/nvim-base16" },
  -- { "gruvbox-community/gruvbox" },
  { "folke/tokyonight.nvim" },
  { "lunarvim/darkplus.nvim" },
  { "sainnhe/gruvbox-material" },
  { "joshdick/onedark.vim" },
  { "kvrohit/rasmus.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rebelot/kanagawa.nvim" },

  -- recommended by the commuity
  -- Everforest
  -- Gruvbox material
  -- One dark
  -- Catppuccin
  -- Nightfox
  -- kanagwa

  -- Configure LazyVim to load preferred scheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave", -- wave the default heart-warming theme,
      -- colorscheme = "kanagawa-dragon",-- dragon for those late-night sessions
      -- colorscheme = "kanagawa-lotus",-- lotus for when you're out in the open.

      -- colorscheme = "gruvbox",
      -- colorscheme = "base16-darcula",
      -- colorscheme = "catppuccin-macchiato",
    },
  },
}
