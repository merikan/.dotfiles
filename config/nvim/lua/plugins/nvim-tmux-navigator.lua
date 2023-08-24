-- make tmux and and nvim work together
-- https://github.com/alexghergh/nvim-tmux-navigation

return {
  "alexghergh/nvim-tmux-navigation",
  lazy = false,
  config = function()
    require("nvim-tmux-navigation").setup {
      disable_when_zoomed = true, -- defaults to false
    }

    -- keymap("n", "<C-h>", ":NvimTmuxNavigateLeft<CR>", { desc = "Go to left window (tmux-aware)", remap = true })
    -- keymap("n", "<C-j>", ":NvimTmuxNavigateDown<CR>", { desc = "Go to lower window (tmux-aware)", remap = true })
    -- keymap("n", "<C-k>", ":NvimTmuxNavigateUp", { desc = "Go to upper window (tmux-aware)", remap = true })
    -- keymap("n", "<C-l>", ":NvimTmuxNavigateRight", { desc = "Go to right window (tmux-aware)", remap = true })
  end,
}
