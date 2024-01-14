-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  my awesome neovim configuration
--
--    ███╗   ███╗███████╗██████╗ ██╗██╗  ██╗ █████╗ ███╗   ██╗
--    ████╗ ████║██╔════╝██╔══██╗██║██║ ██╔╝██╔══██╗████╗  ██║
--    ██╔████╔██║█████╗  ██████╔╝██║█████╔╝ ███████║██╔██╗ ██║
--    ██║╚██╔╝██║██╔══╝  ██╔══██╗██║██╔═██╗ ██╔══██║██║╚██╗██║
--    ██║ ╚═╝ ██║███████╗██║  ██║██║██║  ██╗██║  ██║██║ ╚████║
--    ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
--
--
--  Peter Merikan
--  github.com/merikan
--  https://merikan.com
--
-- to reset all the shit
-- $ rm -rf ~/.local/share/nvim && rm -rf ~/.config/nvim/plugin && rm -rf ~/.cache/nvim
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
-- My config now uses the amazing LazyVim as boilerplate, because I'm a lazy developer ;-)
-- https://www.lazyvim.org/

require("util.globals")
require("util.autocmds")
-- bootstrap LazyVim, lazy.nvim and plugins
require("config.lazy")    -- load lazyVim, because I'm lazy

-- require "user.core.globals"         -- load global functions
-- require "user.core.keymaps"         -- load keybindings
-- require "user.core.autocommands"    -- register autocommands
-- require "user.core.options"         -- load settings
-- require "user.core.plugins"         -- load plugins
-- require "user.lsp"                  -- configure lsp
-- require "user.core.colorscheme"     -- set color scheme
