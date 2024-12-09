-- override snacks in LazyVim
-- https://github.com/folke/snacks.nvim
return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
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
    terminal = {
      win = {
        position = "float",
      },
    },
  },
}
-- ███╗   ███╗███████╗██████╗ ██╗██╗  ██╗ █████╗ ███╗   ██╗
-- ████╗ ████║██╔════╝██╔══██╗██║██║ ██╔╝██╔══██╗████╗  ██║
-- ██╔████╔██║█████╗  ██████╔╝██║█████╔╝ ███████║██╔██╗ ██║
-- ██║╚██╔╝██║██╔══╝  ██╔══██╗██║██╔═██╗ ██╔══██║██║╚██╗██║
-- ██║ ╚═╝ ██║███████╗██║  ██║██║██║  ██╗██║  ██║██║ ╚████║
-- ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
