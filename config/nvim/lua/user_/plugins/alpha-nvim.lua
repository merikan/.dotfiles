-- a fast and fully programmable dashboard for neovim.
-- https://github.com/goolord/alpha-nvim
-- https://github.com/goolord/alpha-nvim/discussions/16

return {
  "goolord/alpha-nvim",                           -- a nvim dashboard
  -- cmd = "Alpha",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function ()
    local alpha = require "alpha"
    local dashboard = require "alpha.themes.dashboard"
    dashboard.section.header.val = {
      "                                                                                       ",
      "╔═════════════════════════════════════════════════════════════════════════════════════╗",
      "║                                                                                     ║",
      "║                                                                                     ║",
      "║                    In software development,                                         ║",
      "║                          complexity might be admired                                ║",
      "║                                but simplicity is always rewarded.                   ║",
      "║                                                                                     ║",
      "║                                                                                     ║",
      "╚═════════════════════════════════════════════════════════════════════════════════════╝",
    }
    dashboard.section.footer.val = {
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
      dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
      dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
      dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }
    dashboard.section.header.opts.hl = "Type"
    dashboard.section.footer.opts.hl = "Normal"
    dashboard.section.buttons.opts.hl = "Keyword"

    -- dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
    -- dashboard.config.layout[3].val = 5
    -- dashboard.config.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}
