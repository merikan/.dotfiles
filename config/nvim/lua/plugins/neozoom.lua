-- Zoom in as a floating window to help you focus.
-- https://github.com/nyngwang/NeoZoom.lua
return {
  "nyngwang/NeoZoom.lua",
  config = true,
  keys = {
      -- stylua: ignore
      {
        "<leader>Z",
        function () vim.cmd('NeoZoomToggle') end,
        desc = "Zoom in/out",
      },
  },
}
