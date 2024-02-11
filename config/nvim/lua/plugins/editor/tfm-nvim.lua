return {
  "rolv-apneseth/tfm.nvim",
  lazy = false,
  opts = {
    file_manager = "yazi",
    enable_cmds = true,
    replace_netrw = true,
    keybindings = {
      ["<ESC>"] = "q",
    },
    ui = {
      border = "none",
      height = 0.95,
      width = 0.95,
      x = 0.5,
      y = 0.5,
    },
  },
  keys = {
    { "<M-o>", "<cmd>Tfm<CR>", desc = "File Manager" },
    { "<leader>fm", "<cmd>Tfm<CR>", desc = "File Manager" },
  },
}
