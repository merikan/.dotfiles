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

      -- close to Neovim's built-in completion keys (:help ins-completion)
      keymap = {
        preset = "default", -- <C-y> accepts
        -- <CR> accepts only an item picked with <C-n>/<C-p>/arrows, never the
        -- preselected one, else a new line. Typing after picking resets it.
        -- Uses blink's internal list state, recheck after blink updates.
        ["<CR>"] = {
          function(cmp)
            if cmp.is_menu_visible() and require("blink.cmp.completion.list").is_explicitly_selected then
              return cmp.accept()
            end
          end,
          "fallback",
        },
        ["<C-n>"] = { "insert_next" }, -- opens the menu if needed, like Neovim
        ["<C-p>"] = { "insert_prev" },
        ["<C-k>"] = false, -- keep digraphs
        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" }, -- :help i_CTRL-S
      },
    })
  end,
}
