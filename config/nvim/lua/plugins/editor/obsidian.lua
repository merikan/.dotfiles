-- A Neovim plugin for writing and navigating an Obsidian vault
-- https://github.com/epwalsh/obsidian.nvim

local prefix = "<leader>O"
return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/Notes/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required.
    },
    keys = {
      { prefix .. "o", "<cmd>ObsidianOpen<CR>", desc = "Open on App" },
      { prefix .. "g", "<cmd>ObsidianSearch<CR>", desc = "Grep" },
      { "<leader>sO", "<cmd>ObsidianSearch<CR>", desc = "Obsidian Grep" },
      { prefix .. "n", "<cmd>ObsidianNew<CR>", desc = "New Note" },
      { prefix .. "<space>", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Files" },
      { prefix .. "b", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
      { prefix .. "t", "<cmd>ObsidianTags<CR>", desc = "Tags" },
      { prefix .. "t", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
      { prefix .. "l", "<cmd>ObsidianLink<CR>", desc = "Link" },
      { prefix .. "L", "<cmd>ObsidianLinks<CR>", desc = "Links" },
      { prefix .. "N", "<cmd>ObsidianLinkNew<CR>", desc = "New Link" },
      { prefix .. "e", "<cmd>ObsidianExtractNote<CR>", desc = "Extract Note" },
      { prefix .. "w", "<cmd>ObsidianWorkspace<CR>", desc = "Workspace" },
      { prefix .. "r", "<cmd>ObsidianRename<CR>", desc = "Rename" },
      { prefix .. "i", "<cmd>ObsidianPasteImg<CR>", desc = "Paste Image" },
      { prefix .. "d", "<cmd>ObsidianDailies<CR>", desc = "Daily Notes" },
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
      spec = {
        { prefix, group = "obsidian" },
      },
    },
  },
}
