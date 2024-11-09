return {
  --  REST Client to send HTTP request and view the response
  --  https://github.com/rest-nvim/rest.nvim
  --  see https://github.com/rest-nvim/rest.nvim/tree/main/spec/examples
  {
    "rest-nvim/rest.nvim",
    ft = { "http" },
    event = "VeryLazy",
    dependencies = {
      { "vhyrro/luarocks.nvim", },
      { "j-hui/fidget.nvim", },
    },
    opts = {
      -- see :h rest-nvim.config for options
    },
    config = function(_, opts)
      -- require("rest-nvim").setup(opts)
      require("lazyvim.util").on_load("telescope.nvim", function()
        require("telescope").load_extension("rest")
      end)
    end,
    -- stylua: ignore
    keys = {
      { "<leader>thr", "<cmd>Rest run<cr>", "Run request under the cursor", },
      { "<leader>thl", "<cmd>Rest run last<cr>", "Re-run latest request", },
      { "<leader>the", function() require("telescope").extensions.rest.select_env() end, desc = "Env Files" },
      { "<leader>sv", function() require("telescope").extensions.rest.select_env() end, desc = "Env Files" },
    },
  },
  {
    "vhyrro/luarocks.nvim",
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "lua", "xml", "http", "json", "graphql" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>th", group = "run rest command" },
      },
    },
  },
}
