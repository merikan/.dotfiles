-- override snacks in LazyVim
-- https://github.com/folke/snacks.nvim
return {
   -- dir = "/Users/peter/Repos/github.com/folke/snacks.nvim",
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
        ███╗   ███╗███████╗██████╗ ██╗██╗  ██╗ █████╗ ███╗   ██╗
        ████╗ ████║██╔════╝██╔══██╗██║██║ ██╔╝██╔══██╗████╗  ██║
        ██╔████╔██║█████╗  ██████╔╝██║█████╔╝ ███████║██╔██╗ ██║
        ██║╚██╔╝██║██╔══╝  ██╔══██╗██║██╔═██╗ ██╔══██║██║╚██╗██║
        ██║ ╚═╝ ██║███████╗██║  ██║██║██║  ██╗██║  ██║██║ ╚████║
        ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
       ╔══════════════════════════════════════════════════════════╗
       ║     In software development,                             ║
       ║           complexity might be admired                    ║
       ║                 but simplicity is always rewarded.       ║
       ║                                                          ║
       ║        Peter Merikan  (https://merikan.com)              ║
       ║         github.com/merikan                               ║
       ╚══════════════════════════════════════════════════════════╝
                powered by LazyVim https://www.lazyvim.org/
        ]],
      },
    },
    lazygit = {
      configure = false,
    },
    notifier = {
      style = "fancy",
    },
    styles = {
      notification = {
        -- prevent core dump
        --  https://www.reddit.com/r/neovim/comments/1r8eo6b/comment/o64mh28
        ft = "",
      },
    },
    picker = {
      hidden = true,
      sources = {
        explorer = {
          show_empty = true,
          hidden = true,
          ignored = true,
        },
      },
    },
    -- terminal = {
    --   win = {
    --     position = "float",
    --   },
    -- },
  },
  keys = {
    { "<leader>fz", function() Snacks.picker.zoxide() end, desc = "Zoxide" },
  },
}
-- ███╗   ███╗███████╗██████╗ ██╗██╗  ██╗ █████╗ ███╗   ██╗
-- ████╗ ████║██╔════╝██╔══██╗██║██║ ██╔╝██╔══██╗████╗  ██║
-- ██╔████╔██║█████╗  ██████╔╝██║█████╔╝ ███████║██╔██╗ ██║
-- ██║╚██╔╝██║██╔══╝  ██╔══██╗██║██╔═██╗ ██╔══██║██║╚██╗██║
-- ██║ ╚═╝ ██║███████╗██║  ██║██║██║  ██╗██║  ██║██║ ╚████║
-- ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
