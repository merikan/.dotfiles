-- A Neovim plugin for writing and navigating an Obsidian vault
-- https://github.com/epwalsh/obsidian.nvim
return {

  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required.
    { -- adds horizontal highlights for text filetypesinit.lua
      "lukas-reineke/headlines.nvim",
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = true,
    },
    -- see below for full list of optional dependencies 👇
  },
  keys = {
    { "<leader>oo", "<cmd>ObsidianOpen<cr>" },
    { "<leader>on", "<cmd>ObsidianNew<cr>" },
    { "<leader>oT", "<cmd>ObsidianTemplate<cr>" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>" },
    { "<leader>ol", "<cmd>ObsidianLink<cr>" },
    { "<leader>oL", "<cmd>ObsidianLinkNew<cr>" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>" },
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/obsidian",
      },
    },
    templates = {
      subdir = "Templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
    note_id_func = function(title) return tostring(title) end,
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- if cursor is on a link in an obsidian file, gf will follow the reference, otherwise it will behave normally
    vim.keymap.set("n", "gf", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gf"
      end
    end, { noremap = false, expr = true })
  end,
},
-- add menu
{
  "folke/which-key.nvim",
  opts = function(_, opts)
    opts.defaults["<leader>o"] = { name = "+obsidian" }
  end,
}
