return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("typescript", { "tsdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("typescript", { "next-ts" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("javascript", { "jsdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("javascript", { "next" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("lua", { "luadoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("python", { "pydoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("rust", { "rustdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("cs", { "csharpdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("java", { "javadoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("c", { "cdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("cpp", { "cppdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("php", { "phpdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("kotlin", { "kdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("ruby", { "rdoc" })
        require("config.nvim.lua.plugins.coding.luasnip").filetype_extend("sh", { "shelldoc" })
        require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
      end,
    },
  },
  {
    "garymjr/nvim-snippets",
    enabled = false,
  },
}
