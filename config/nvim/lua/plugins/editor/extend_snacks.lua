return {
   -- dir = "/Users/peter/Repos/github.com/folke/snacks.nvim",
  "folke/snacks.nvim",
  opts = {
    styles = {
      notification = {
        -- prevent core dump
        --  https://www.reddit.com/r/neovim/comments/1r8eo6b/comment/o64mh28
        ft = "",
      },
    },
    picker = {
      sources = {
        explorer = {
          show_empty = true,
          hidden = true,
          ignored = true,
        },
      },
    },
  },
}
