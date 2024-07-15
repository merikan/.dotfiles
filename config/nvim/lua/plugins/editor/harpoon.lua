-- https://github.com/ThePrimeagen/harpoon
local prefix = "<leader>h"
local keys = {}

-- stylua: ignore start
for i = 1, 9 do
  table.insert(keys, { prefix .. i, function() require("harpoon"):list():select(i) end, desc = "File " .. i })
end

table.insert(keys, { prefix .. "a", function() require("harpoon"):list():append() end, desc = "Add Mark" })
table.insert(keys, { prefix .. "h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Menu" })
table.insert(keys, { prefix .. "f", "<cmd>Telescope harpoon marks<CR>", desc = "Files" })

table.insert(keys, { "]H", function() require("harpoon"):list():next() end, desc = "Next Harpoon File" })
table.insert(keys, { "[H", function() require("harpoon"):list():prev() end, desc = "Prev Harpoon File" })
-- stylua: ignore end

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    --stylua: ignore
    keys = keys,
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-x>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })

      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").load_extension("harpoon")
      end)
    end,
  },
  -- add menu
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "harpoon" },
      },
    },
  },
}
