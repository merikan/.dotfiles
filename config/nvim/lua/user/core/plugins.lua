-- The Lazy package manager by Folke
-- https://github.com/folke/lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("===============================")
  vim.notify("    Bootstrapping lazy.nvim    ")
  vim.notify("===============================")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

local lazy = require("lazy")
local ui = require("user.core.ui")

-- make sure to set `mapleader` before lazy so your mappings are correct
-- every plugin to be installed is declared in folder lua/user/plugins
lazy.setup("user.plugins", {
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  ui = {
    -- a number <1 is a percentage., >1 is a fixed size
    size = { width = 0.8, height = 0.8 },
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = ui.border.Single,
  },
})

