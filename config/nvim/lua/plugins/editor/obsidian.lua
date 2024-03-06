-- A Neovim plugin for writing and navigating an Obsidian vault
-- https://github.com/epwalsh/obsidian.nvim
-- if true then return {} end
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
  },
  keys = {
    { "<leader>oo", "<cmd>ObsidianOpen<CR>", desc = "Open in App" },
    { "<leader>og", "<cmd>ObsidianSearch<CR>", desc = "Grep" },
    { "<leader>sO", "<cmd>ObsidianSearch<CR>", desc = "Obsidian Grep" },
    { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New Note" },
    { "<leader>o<space>", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Files" },
    { "<leader>fo", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Obsidian Files" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "tomorrow note" },
    { "<leader>o#", "<cmd>ObsidianTags<CR>", desc = "Tags" },
    { "<leader>oT", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
    { "<leader>ol", "<cmd>ObsidianLink<CR>", desc = "Link" },
    { "<leader>oL", "<cmd>ObsidianLinks<CR>", desc = "Links" },
    { "<leader>oN", "<cmd>ObsidianLinkNew<CR>", desc = "New Link" },
    { "<leader>oe", "<cmd>ObsidianExtractNote<CR>", desc = "Extract Note" },
    { "<leader>ow", "<cmd>ObsidianWorkspace<CR>", desc = "Workspace" },
    { "<leader>or", "<cmd>ObsidianRename<CR>", desc = "Rename" },
    { "<leader>oi", "<cmd>ObsidianPasteImg<CR>", desc = "Paste Image" },
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Notes",
      },
    },
    templates = {
      subdir = "Templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
        tomorrow = function()
          return os.date("%Y-%m-%d", os.time() + 86400)
        end,
      },
    },
    note_id_func = function(title)
      return tostring(title)
    end,
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
  opts = {
    defaults = {
      ["<leader>o"] = { name = "obsidian" },
    },
  },
}
