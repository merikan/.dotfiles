-- override/extend lazyvim default config

-- a fast and fully programmable dashboard for neovim.
-- https://github.com/goolord/alpha-nvim
-- https://github.com/goolord/alpha-nvim/discussions/16

return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    local dashboard = opts
    local logo = [[
    ███╗   ███╗███████╗██████╗ ██╗██╗  ██╗ █████╗ ███╗   ██╗
    ████╗ ████║██╔════╝██╔══██╗██║██║ ██╔╝██╔══██╗████╗  ██║
    ██╔████╔██║█████╗  ██████╔╝██║█████╔╝ ███████║██╔██╗ ██║
    ██║╚██╔╝██║██╔══╝  ██╔══██╗██║██╔═██╗ ██╔══██║██║╚██╗██║
    ██║ ╚═╝ ██║███████╗██║  ██║██║██║  ██╗██║  ██║██║ ╚████║
    ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝

    Peter Merikan  (https://merikan.com)
    github.com/merikan
    ]]
    dashboard.section.header.val = vim.split(logo, "\n")
    local footer = [[
        ╔══════════════════════════════════════════════════════════╗
        ║                                                          ║
        ║     In software development,                             ║
        ║           complexity might be admired                    ║
        ║                 but simplicity is always rewarded.       ║
        ║                                                          ║
        ╚══════════════════════════════════════════════════════════╝
    ]]
    dashboard.section.footer.val = vim.split(footer, "\n")
  end,
}
