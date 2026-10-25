-- override snacks in LazyVim
-- https://github.com/folke/snacks.nvim
return {
   -- dir = "/Users/peter/Repos/github.com/folke/snacks.nvim",
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        -- my own ascii banner and quote on the start screen
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
      configure = false, -- use my own lazygit config, don't inject colorscheme/editor settings
    },
    notifier = {
      style = "fancy", -- nvim-notify like notifications (default is compact)
    },
    styles = {
      notification = {
        -- prevent core dump
        --  https://www.reddit.com/r/neovim/comments/1r8eo6b/comment/o64mh28
        ft = "",
      },
    },
    picker = {
      hidden = true, -- include dotfiles in pickers that support it (files, grep, ...)
      sources = {
        explorer = {
          show_empty = true, -- keep the explorer open with no items (empty dir, no matches)
          hidden = true, -- show dotfiles
          ignored = true, -- show git-ignored files
          jump = { close = true }, -- close the explorer after opening a file
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
