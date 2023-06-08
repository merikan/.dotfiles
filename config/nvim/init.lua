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

require "user.core.globals"         -- load global functions
require "user.core.keymaps"         -- load keybindings
require "user.core.autocommands"    -- register autocommands
require "user.core.options"         -- load settings
require "user.core.plugins"         -- load plugins
require "user.lsp"                  -- configure lsp
require "user.core.colorscheme"     -- set color scheme
