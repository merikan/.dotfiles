-- completion
-- https://github.com/Saghen/blink.cmp
return {
  "saghen/blink.cmp",
  -- a function, because LazyVim lists sources.default in opts_extend,
  -- so a table would append to its list instead of replacing it
  opts = function(_, opts)
    opts.sources.default = { "lsp", "path", "snippets" } -- no buffer words

    return vim.tbl_deep_extend("force", opts, {
      signature = { enabled = true },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    })
  end,
}
