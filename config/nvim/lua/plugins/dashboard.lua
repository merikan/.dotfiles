-- override/extend lazyvim default config

return {
  "nvimdev/dashboard-nvim",
  opts = function(_, opts)
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

    logo = string.rep("\n", 8) .. logo .. "\n\n"
    opts.config.header = vim.split(logo, "\n")

    local footer = [[
        ╔══════════════════════════════════════════════════════════╗
        ║                                                          ║
        ║     In software development,                             ║
        ║           complexity might be admired                    ║
        ║                 but simplicity is always rewarded.       ║
        ║                                                          ║
        ╚══════════════════════════════════════════════════════════╝

                powered by LazyVim https://www.lazyvim.org/
    ]]
    footer = string.rep("\n", 2) .. footer .. "\n\n"
    local lazy_footer = opts.config.footer()
    opts.config.footer = vim.tbl_extend('keep', vim.split(footer, "\n"), lazy_footer)
  end,
}
