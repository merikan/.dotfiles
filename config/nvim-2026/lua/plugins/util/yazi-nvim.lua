-- yazi terminal file manager
-- https://github.com/mikavilpas/yazi.nvim
return
{
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    { "<M-o>", "<cmd>Yazi<CR>", desc = "Open file in File Manager" },
    { "<leader>Y", "<cmd>Yazi cwd<CR>", desc = "File Manager" },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = '<f1>',
    },
  },
}
