local M = {}

-- protected require
M.prequire = function(req_name)
  if req_name then
    local status, lib = pcall(require, req_name)
    if status then
      return lib
    end
  end
  return nil
end

-- key mapper function(s)
local keymap = {}

local keymapper = function(mode, lhs, rhs, opts)
  local default_opts = { noremap = true, silent = true }
  opts = opts or {}
  opts = vim.tbl_extend("force", opts, default_opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

keymap.map = function(mode, lhs, rhs, opts)
  return keymapper(mode, lhs, rhs, opts)
end

keymap.buf_map = function(bufnr, mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = bufnr
  return keymapper(mode, lhs, rhs, opts)
end

M.keymap = keymap

--- Check if a plugin is defined in lazy. Useful with lazy loading when a plugin is not necessarily loaded yet
-- @param plugin the plugin string to search for
-- @return boolean value if the plugin is available
function M.is_plugin_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.plugins[plugin] ~= nil
end

return M
