
return {
  "FabijanZulj/blame.nvim",
  opts = {
    mappings = {
      commit_info = "K",
    },
  },
  keys = {
    { "<leader>g+B", "<cmd>BlameToggle<cr>", desc = "Blame View" },
  },
}
