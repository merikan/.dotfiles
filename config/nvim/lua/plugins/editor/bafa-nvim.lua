return {
  "mistweaverco/bafa.nvim",
  keys = {
    { "<leader>bb", "<cmd>lua require('bafa.ui').toggle()<cr>" },
  },
  opts = {
    ui = {
      title = {
        text = "bafa",
      },
    },
  },
}
