-- miscellaneous plugins
--
--
return {
  -- Delete neovim buffers without losing window layout
  -- https://github.com/famiu/bufdelete.
  { "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
  },

  -- Color highlighter for Neovim
  -- https://github.com/NvChad/nvim-colorizer.lua
  { "NvChad/nvim-colorizer.lua",
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    opts = { user_default_options = { names = false } },
  },


  -- Escape from insert mode without delay when typing
  -- https://github.com/max397574/better-escape.nvim
  { "max397574/better-escape.nvim", event = "InsertCharPre", opts = { timeout = 300 } },

  -- Automatic indentation style detection for neovim
  -- https://github.com/NMAC427/guess-indent.nvim
  { "NMAC427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup()
      vim.cmd.lua { args = { "require('guess-indent').set_from_buffer('auto_cmd')" }, mods = { silent = true } }
    end
  },

  -- Prompts the user to pick a window by id
  -- https://github.com/s1n7ax/nvim-window-picker
  { "s1n7ax/nvim-window-picker", opts = { use_winbar = "smart" } },

  -- Directional navigation and resizing of Neovim + terminal multiplexer splits.
  -- https://github.com/mrjones2014/smart-splits.nvim
  {
    "mrjones2014/smart-splits.nvim",
    opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
  },

}
