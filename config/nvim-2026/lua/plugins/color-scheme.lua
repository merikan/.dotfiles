return {
  -- stylua: ignore start

  -- https://github.com/folke/tokyonight.nvim
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {}, },
  -- https://github.com/rebelot/kanagawa.nvim
  { "rebelot/kanagawa.nvim" },
  -- https://github.com/webhooked/kanso.nvim
  { "webhooked/kanso.nvim", lazy = false, priority = 1000, },
  -- https://gitlab.com/motaz-shokry/gruvbox.nvim
  { "https://gitlab.com/motaz-shokry/gruvbox.nvim", name = "gruvbox", priority = 1000, },

  -- activate theme
  { "LazyVim/LazyVim", opts = { colorscheme = "kanso-mist" }},
}
