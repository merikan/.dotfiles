-- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
-- https://github.com/sindrets/diffview.nvim
return   {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {},
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  }
