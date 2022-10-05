-- install packer.nvim and plugins
-- https://github.com/wbthomason/packer.nvim
--
-- :PackerCompile                    - Regenerate compiled loader file
-- :PackerClean                      - Remove any disabled or unused plugins
-- :PackerInstall                    - Clean, then install missing plugins
-- :PackerUpdate                     - Clean, then update and install plugins
-- :PackerSync                       - Perform `PackerUpdate` and then `PackerCompile`
-- :PackerLoad completion-nvim ale   - Loads opt plugin immediately

local execute = vim.api.nvim_command
local fn = vim.fn
local CURDIR = (...):match "(.-)[^%.]+$"

local packer_init = false
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_init = true
  vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})
  execute("!git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
  execute "packadd packer.nvim"
end

local packer = require "packer"

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- reload if this buffer changes
vim.cmd [[
  augroup packer_refresh
  autocmd!
  autocmd BufWritePost plugins.lua PackerClean
  autocmd BufWritePost plugins.lua PackerInstall
  autocmd BufWritePost plugins.lua PackerCompile
  augroup END
]]

return packer.startup(function(use)
  use { "wbthomason/packer.nvim" }
  use { "nvim-telescope/telescope.nvim", -- a picky fuzzy finder
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope-project.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = function()
      require("user.plugins.telescope").setup()
    end,
  }
  use { "nvim-treesitter/nvim-treesitter", -- treesitter render AST for languages
    requires = {
      -- "nvim-treesitter/nvim-treesitter-refactor",
      -- "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    run = ":TSUpdate",
    config = function()
      require("user.plugins.treesitter").setup()
    end,
  }

  -- LSP  - Language Server Protocol
  use { "neovim/nvim-lspconfig", -- common lsp configurations
    requires = {
      "williamboman/nvim-lsp-installer", -- lsp installer
      "folke/lua-dev.nvim", -- setup for lua dev
      "b0o/SchemaStore.nvim", -- providing access to the SchemaStore catalog.
      {
        "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
        after = "nvim-lspconfig",
        config = function()
          require("user.lsp.null-ls").setup()
        end,
      },
    },
    after = "cmp-nvim-lsp",
    config = function()
      require("user.lsp").setup()
    end,
  }
  -- Java
  use "mfussenegger/nvim-jdtls"

  -- debugger (DAP)
  -- use "mfussenegger/nvim-dap"
  -- use "theHamsta/nvim-dap-virtual-text"
  -- use "rcarriga/nvim-dap-ui"
  -- use "Pocco81/DAPInstall.nvim"

  -- snippets
  use { "L3MON4D3/LuaSnip", --snippet engine
    requires = "rafamadriz/friendly-snippets", -- a bunch of snippets to use
  }
  -- autocompletion
  use { "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp", -- nvim-cmp for lsp
      "onsails/lspkind-nvim", -- pictograms for completion items
      "hrsh7th/cmp-buffer", -- nvim-cmp for buffer words
      "hrsh7th/cmp-path", -- nvim-cmp for path
      "hrsh7th/cmp-cmdline", -- nvim-cmp for vim cmdline
      "saadparwaiz1/cmp_luasnip", -- snippet completions
      "hrsh7th/cmp-nvim-lua", -- nvim-cmp for nvim lua
      "f3fora/cmp-spell", -- nvim-cmp for vim spell
      "ray-x/cmp-treesitter", -- cmp for treesitter
      "Saecki/crates.nvim", -- cmp for rust crates
    },
    config = function()
      require("user.plugins.cmp").setup()
    end,
  }
  use "windwp/nvim-autopairs" -- autopairs parentheses, brackets, quotes etc.
  use "tpope/vim-surround" --  all about "surroundings": parentheses, brackets, quotes, XML tags, and more.
  use { "folke/trouble.nvim", -- handle diagnostics with grace
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("user.plugins.trouble").setup()
    end,
  }
  use { "numToStr/Comment.nvim", -- line/block comments
    requires = {
      { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
    },
    config = function()
      require("user.plugins.comment").setup()
    end,
  }
  use { "folke/todo-comments.nvim", -- manage your todos with grace
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  }
  use "editorconfig/editorconfig-vim" -- consistent coding style
  -- use {
  --   "lukas-reineke/indent-blankline.nvim", -- make indention more appealing
  --   config = function()
  --     require("indent_blankline").setup {
  --       show_current_context = true,
  --       show_current_context_start = true,
  --       show_end_of_line=true,
  --     }
  --   end,
  -- }
  use {
    "norcalli/nvim-colorizer.lua", -- colorize color codes
    opt = true,
    cmd = { "ColorizerToggle" },
    config = function()
      require("colorizer").setup()
    end,
  }
  use { "christoomey/vim-tmux-navigator" } -- make tmux and and vim work together
  use {
    "lewis6991/gitsigns.nvim", -- git integration
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("gitsigns").setup()
    end,
  }
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  }

  -- ==============
  -- look and feel
  -- ==============
  use {
    "goolord/alpha-nvim", -- a nvim dashboard
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("user.plugins.alpha-nvim").setup()
    end,
  }
  use {
    "kyazdani42/nvim-tree.lua", -- file explorer
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("user.plugins.nvim-tree").setup()
      -- require(CURDIR .."nvim-tree").setup()
    end,
  }
  -- colorscheme(s)
  use {
    "doums/darcula",
    config = function()
      require "user.themes.darcula"
    end,
  }
  -- use "chriskempson/base16-vim"
  -- use "gruvbox-community/gruvbox"
  -- use {
  --   "morhetz/gruvbox",
  --   config = function()
  --     vim.o.termguicolors = true
  --     vim.cmd "colorscheme gruvbox"
  --   end,
  -- }
  -- use "joshdick/onedark.vim"

  use {
    "nvim-lualine/lualine.nvim", -- a nice statusline
    requires = {
      "arkav/lualine-lsp-progress",
      "kyazdani42/nvim-web-devicons",
      opt = true,
    },
    config = function()
      require("user.plugins.lualine").setup()
    end,
  }
  use {
    "moll/vim-bbye", -- close buffers right

    config = function()
      require("user.plugins.bbye").setup()
    end,
  }
  use {
    "akinsho/bufferline.nvim", --  handle buffers nicely
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require("user.plugins.bufferline").setup()
    end,
  }

  if packer_init then
    require("packer").sync()
  end
end)

--     use {
--       -- "hrsh7th/nvim-cmp",
--       requires = {
--         -- { "hrsh7th/cmp-buffer" },
--         -- { "hrsh7th/cmp-nvim-lsp" },
--         -- { "hrsh7th/cmp-path" },
--         -- { "hrsh7th/cmp-nvim-lua" },
--         -- { "ray-x/cmp-treesitter" },
--         -- { "hrsh7th/nvim-cmp" },
--         -- { "hrsh7th/cmp-vsnip" },
--         -- { "hrsh7th/vim-vsnip" },
--         { "Saecki/crates.nvim" },
--         -- { "f3fora/cmp-spell" },
--         -- { "hrsh7th/cmp-cmdline" },
--         { "tamago324/cmp-zsh" },
--       },
--       config = function()
--         require "joel.completion"
--       end,
--     }

--   -- use {"hrsh7th/cmp-path"}
--   -- use {"hrsh7th/cmp-cmdline"}
--   -- use {"hrsh7th/nvim-cmp"}
--   -- -- snippets
--   -- use {"hrsh7th/cmp-vsnip"}
--   -- use {"hrsh7th/vim-vsnip"}

--   -- -- extend lsp with saga
--   -- use {"glepnir/lspsaga.nvim"}
--   -- -- signature hints
--   -- use {"ray-x/lsp_signature.nvim"}

--   -- use { "vinicius507/norme.nvim", requires = { "mfussenegger/nvim-lint" } }

--   -- use { "tjdevries/nlua.nvim" }

--   -- use { "eduardomosko/header42.nvim" }

--   -- use { "norcalli/nvim-colorizer.lua" }

--   -- use { "lunarWatcher/auto-pairs" }

--   -- use { "folke/lsp-colors.nvim" }

--   -- use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }

--   -- use { "mfussenegger/nvim-dap" }

--   -- use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

--   -- use { "TimUntersberger/neogit", requires = { "nvim-lua/plenary.nvim" } }

--   -- use { "sindrets/diffview.nvim" }

--   -- use { "kyazdani42/nvim-tree.lua" , requires = { "kyazdani42/nvim-web-devicons" } }

--   -- use { "hoob3rt/lualine.nvim", requires = {"kyazdani42/nvim-web-devicons", opt = true} }

--   -- use { "andweeb/presence.nvim" }

--   -- use {"akinsho/nvim-toggleterm.lua"}

--   -- =========================
--   -- Other Plugins
--   -- =========================
