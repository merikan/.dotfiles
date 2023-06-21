-- override/extend lazyvim default config
-- https://github.com/nvim-neo-tree/neo-tree.nvim
--
-- parts are borrowed from AstroNvim https://github.com/AstroNvim/AstroNvim/blob/main/lua/plugins/neo-tree.lua
-- especially navigation with hl

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- auto_clean_after_session_restore = true,
    -- close_if_last_window = true,
    -- sources = { "filesystem", "buffers", "git_status" },
    -- source_selector = {
    --   winbar = true,
    --   content_layout = "center",
    --   sources = {
    --     { source = "filesystem", display_name = "File" },
    --     { source = "buffers", display_name = "Bufs" },
    --     { source = "git_status", display_name = "Git" },
    --     { source = "diagnostics", display_name = "Diagnostic" },
    --   },
    -- },
    -- default_component_configs = {
    --   indent = { padding = 0, indent_size = 1 },
    -- },
    commands = {
      parent_or_close = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
      child_or_open = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          if not node:is_expanded() then -- if unexpanded, expand
            state.commands.toggle_node(state)
          else -- if expanded and has children, seleect the next child
            require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
          end
        else -- if not a directory just open it
          state.commands.open(state)
        end
      end,
    },
    window = {
      width = 30,
      mappings = {
        ["<space>"] = false, -- disable space until we figure out which-key disabling
        ["[b"] = "prev_source",
        ["]b"] = "next_source",
        o = "open",
        O = "system_open",
        h = "parent_or_close",
        l = "child_or_open",
      },
    },
    filesystem = {
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_) vim.opt_local.signcolumn = "auto" end,
      },
    },
  },
}
