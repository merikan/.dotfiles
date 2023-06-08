-- A fast statusline plugin
-- https://github.com/nvim-lualine/lualine.nvim

local M = { "nvim-lualine/lualine.nvim" }

function M.config()
  local navic = require("nvim-navic")

  local function custom_mode()
    return [[ ]]
  end
  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end
  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    always_visible = true,
  }
  local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width,
  }
  local filetype = {
    "filetype",
    icons_enabled = false,
  }
  local location = {
    "location",
    padding = 0,
  }
  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  require("lualine").setup({
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {"branch"},
      lualine_c = { diagnostics },
      lualine_d = {
        {
          navic.get_location,
          cond = navic.is_available,
          color = "WinBarInactive",
        },
      },
      lualine_x = { diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { "progress" },
    },
  })
end

return M
