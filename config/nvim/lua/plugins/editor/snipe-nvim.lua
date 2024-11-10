return {
  -- menu built for fast buffer navigation
  -- https://github.com/leath-dub/snipe.nvim
  {
    "leath-dub/snipe.nvim",
    keys = {
      {
        "gb",
        function()
          require("snipe").open_buffer_menu()
        end,
        desc = "Open Snipe buffer menu",
      },
    },
    opts = {},
  },
}
