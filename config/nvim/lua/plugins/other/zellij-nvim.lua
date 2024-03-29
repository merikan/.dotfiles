-- Zellij integration for neovim
-- https://github.com/Lilja/zellij.nvim
return {
  "Lilja/zellij.nvim",
  lazy = true,
  enabled = vim.env.ZELLIJ ~= nil,
  opts = {
    whichKeyEnabled = true,
    vimTmuxNavigatorKeybinds = true, -- C+[hjkl]
    -- debug = true,
  }
}
