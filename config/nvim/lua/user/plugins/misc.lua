return {
  -- delete neovim buffers without losing window layout
  -- https://github.com/famiu/bufdelete.
  { "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
  },

  -- color highlighter for Neovim
  -- https://github.com/NvChad/nvim-colorizer.lua
  { "NvChad/nvim-colorizer.lua",
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    opts = { user_default_options = { names = false } },
  },


  { "max397574/better-escape.nvim", event = "InsertCharPre", opts = { timeout = 300 } },
  { "NMAC427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup()
      vim.cmd.lua { args = { "require('guess-indent').set_from_buffer('auto_cmd')" }, mods = { silent = true } }
    end
  },
  { "s1n7ax/nvim-window-picker", opts = { use_winbar = "smart" } },
  {
    "mrjones2014/smart-splits.nvim",
    opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
  },

}
