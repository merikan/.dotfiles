local M = {}

-- protected require
M.prequire = function(...)
  local status, lib = pcall(require, ...)
  if (status) then return lib end
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
	return keymapper(mode, lhs, rhs, options)
end

keymap.buf_map = function(bufnr, mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = bufnr
	return keymapper(mode, lhs, rhs, options)
end

M.keymap = keymap


--- Check if a plugin is defined in lazy. Useful with lazy loading when a plugin is not necessarily loaded yet
-- @param plugin the plugin string to search for
-- @return boolean value if the plugin is available
function M.is_plugin_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.plugins[plugin] ~= nil
end

--
-- local diagnostics_active = true
-- G.toggle_diagnostics = function()
--     diagnostics_active = not diagnostics_active
--     if diagnostics_active then
--         vim.diagnostic.show()
--     else
--         vim.diagnostic.hide()
--     end
-- end
--
-- local diagnostics_loclist_active = false
-- G.toggle_diagnostics_loclist = function()
--     diagnostics_loclist_active = not diagnostics_loclist_active
--     if diagnostics_loclist_active then
--         vim.diagnostic.setloclist()
--     else
--         vim.cmd('lclose')
--     end
-- end
--
--
--
-- -- https://github.com/quantumsnowball/nvim/tree/master/lua/plugins/editing/layout
-- -- simple custom function to toggle maximize pane and restore
-- local isZoomed = false
--
-- local function toggleMaximize()
--     if (isZoomed) then
--         vim.cmd 'wincmd ='
--     else
--         vim.api.nvim_win_set_width(0, 99999)
--         vim.api.nvim_win_set_height(0, 99999)
--     end
--     isZoomed = not isZoomed
-- end

-- local map = require('utils').map
-- vim.keymap.set('n', 'gm', toggleMaximize)
-- vim.keymap.set('n', '<leader>z', toggleMaximize)

-- Zoom / Restore windws
-- vim.cmd([[
-- function! s:ZoomToggle() abort
--     if exists('t:zoomed') && t:zoomed
--         execute t:zoom_winrestcmd
--         let t:zoomed = 0
--     else
--         let t:zoom_winrestcmd = winrestcmd()
--         resize
--         vertical resize
--         let t:zoomed = 1
--     endif
-- endfunction
-- command! ZoomToggle call s:ZoomToggle()
-- ]])

return M
