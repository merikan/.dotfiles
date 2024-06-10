return {
  -- uses virtual text and gutter signs to show available motions.
  -- https://github.com/tris203/precognition.nvim
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>u+p", "<cmd>Precognition toggle<CR>", { desc = "Precognition toggle" }},
    },
    init = function() end,
    opts = {
      startVisible = false,
      showBlankVirtLine = false,
      highlightColor = { link = "@variable.parameter" },
      hints = {
        Caret = { text = "^", prio = 2 },
        Dollar = { text = "$", prio = 1 },
        MatchingPair = { text = "%", prio = 5 },
        Zero = { text = "0", prio = 1 },
        w = { text = "w", prio = 10 },
        b = { text = "b", prio = 9 },
        e = { text = "e", prio = 8 },
        W = { text = "W", prio = 7 },
        B = { text = "B", prio = 6 },
        E = { text = "E", prio = 5 },
      },
      gutterHints = {
        G = { text = "G", prio = 10 },
        gg = { text = "gg", prio = 9 },
        PrevParagraph = { text = "{", prio = 8 },
        NextParagraph = { text = "}", prio = 8 },
      },
    },
  },
}
