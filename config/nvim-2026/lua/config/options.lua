-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local o = vim.opt
local g = vim.g

-- just to be sure ;-)
g.mapleader = " "
g.maplocalleader = " "

--------------------------------------------------------------------------------
-- Core
--------------------------------------------------------------------------------
o.clipboard = "unnamed,unnamedplus"                                   -- keep in sync with the system clipboard
-- o.clipboard:prepend({ "unnamed", "unnamedplus" }) -- use system buffer (cross-platform)
o.fileencoding = "utf-8" -- the encoding written to a file
-- o.mouse = "a" -- allow the mouse to be used in neovim
o.autoread = true -- automatically reload a file
g.autoformat = false -- disable LazyVim auto format
--------------------------------------------------------------------------------
-- Lines
--------------------------------------------------------------------------------
o.scrolloff = 0 -- Lines of context
o.list = true -- :set list, :set nolist
o.listchars:append("trail:•")
o.listchars:append("eol:↴")
o.listchars:append("tab:» ")
o.listchars:append("extends:❯")
o.listchars:append("precedes:❮")
o.listchars:append("nbsp:_")
o.listchars:append("space:.")
--------------------------------------------------------------------------------
-- Backup / Undo / Swap
--------------------------------------------------------------------------------
o.backup = false -- creates a backup file
o.undofile = true -- enable persistent undo
o.swapfile = false -- creates a swapfile
o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
