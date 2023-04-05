-- highlight words under cursor using LSP, Tree-sitter, or regex matching
-- https://github.com/RRethy/vim-illuminate

local M = { "RRethy/vim-illuminate" }

function M.config()

  vim.g.Illuminate_ftblacklist = { 'alpha', 'NvimTree' }

  require("illuminate").configure({
    providers = {
      "lsp",
      "treesitter",
      "regex",
    },
    delay = 200,
    filetypes_denylist = {
      "dirvish",
      "fugitive",
      "alpha",
      "NvimTree",
      "packer",
      "neogitstatus",
      "Trouble",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "TelescopePrompt",
    },
    filetypes_allowlist = {},
    modes_denylist = {},
    modes_allowlist = {},
    providers_regex_syntax_denylist = {},
    providers_regex_syntax_allowlist = {},
    under_cursor = true,
  })
end

return M
