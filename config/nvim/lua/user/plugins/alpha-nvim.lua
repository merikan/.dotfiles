-- https://github.com/goolord/alpha-nvim
-- https://github.com/goolord/alpha-nvim/discussions/16
local M = {}

M.setup = function()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"
  dashboard.section.header.val = {
    [[                                                          ]],
    [[                                                          ]],
    [[ ███╗   ███╗███████╗██████╗ ██╗██╗  ██╗ █████╗ ███╗   ██╗ ]],
    [[ ████╗ ████║██╔════╝██╔══██╗██║██║ ██╔╝██╔══██╗████╗  ██║ ]],
    [[ ██╔████╔██║█████╗  ██████╔╝██║█████╔╝ ███████║██╔██╗ ██║ ]],
    [[ ██║╚██╔╝██║██╔══╝  ██╔══██╗██║██╔═██╗ ██╔══██║██║╚██╗██║ ]],
    [[ ██║ ╚═╝ ██║███████╗██║  ██║██║██║  ██╗██║  ██║██║ ╚████║ ]],
    [[ ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ]],
    [[                                                          ]],
    [[ Peter Merikan  (https://merikan.com)                     ]],
    [[ github.com/merikan                                       ]],
  }
  dashboard.section.buttons.val = {
    dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
    dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", "  NVim Configuration", ":e ~/.config/nvim/init.lua <CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
  }

  dashboard.section.footer.val = {
    "                                                                                       ",
    "                                                                                       ",
    "                                                                                       ",
    "                                                                                       ",
    "In software development, complexity might be admired but simplicity is always rewarded.",
  }
  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

  dashboard.opts.opts.noautocmd = true
  -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
  alpha.setup(dashboard.opts)
end

return M