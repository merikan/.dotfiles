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
  -- https://github.com/neanias/everforest-nvim
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      local function set_everforest_terminal_colors()
        vim.g.terminal_color_0 = "#272E33"
        vim.g.terminal_color_1 = "#E67E80"
        vim.g.terminal_color_2 = "#A7C080"
        vim.g.terminal_color_3 = "#DBBC7F"
        vim.g.terminal_color_4 = "#7FBBB3"
        vim.g.terminal_color_5 = "#D699B6"
        vim.g.terminal_color_6 = "#83C092"
        vim.g.terminal_color_7 = "#D3C6AA"
        vim.g.terminal_color_8 = "#859289"
        vim.g.terminal_color_9 = "#E67E80"
        vim.g.terminal_color_10 = "#A7C080"
        vim.g.terminal_color_11 = "#DBBC7F"
        vim.g.terminal_color_12 = "#7FBBB3"
        vim.g.terminal_color_13 = "#D699B6"
        vim.g.terminal_color_14 = "#83C092"
        vim.g.terminal_color_15 = "#D3C6AA"
      end

      vim.o.background = "dark"
      require("everforest").setup({
        background = "hard",
        transparent_background_level = 2,
      })

      local group = vim.api.nvim_create_augroup("everforest_terminal_colors", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        pattern = "everforest",
        callback = set_everforest_terminal_colors,
      })
      set_everforest_terminal_colors()
    end,
  },

  -- activate theme
  { "LazyVim/LazyVim", opts = { colorscheme = "everforest" }},
}
