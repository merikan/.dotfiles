-- protected require
_G.prequire = function(...)
  local status, lib = pcall(require, ...)
  if (status) then return lib end
  return nil
end

-- key mapper function(s)
local default_opts = { noremap = true, silent = true }
_G.keymap = function(mode, lhs, rhs, opts)
  local options = opts or default_opts
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

_G.buf_keymap = function(bufnr, mode, lhs, rhs, opts)
  local options = opts or default_opts
	vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

-- wrapper for nvim_set_keymap with sensible defaults
local keymapper = function(mode, lhs, rhs, override_opts, bufnr)
  -- set default options
  local opts = { noremap = true, silent = true }
  local buf_local = false

  -- if the user wants a buffer_local mapping, take note
  -- because we have to use nvim_buf_set_keymap instead
  if override_opts then
    if override_opts.buffer then
      -- remove buffer key from override_opts table
      override_opts.buffer = nil
      buf_local = true
    end
    -- extend the default options with user's overrides
    vim.tbl_extend('keep', override_opts, opts)
  end

  if buf_local then
    -- set a buffer-local mapping
    vim.api.nvim_buf_set_keymap(bufnr or 0, mode, lhs, rhs, opts)
  else
    -- set a regular global mapping
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

-- set a key mapping for normal mode
_G.nnoremap = function(lhs, rhs, opts, bufnr)
  keymapper('n', lhs, rhs, opts, bufnr)
end
-- set a key mapping for insert mode
_G.inoremap = function(lhs, rhs, opts, bufnr)
  keymapper('i', lhs, rhs, opts, bufnr)
end
-- set a key mapping for visual mode
_G.vnoremap = function(lhs, rhs, opts, bufnr)
  keymapper('v', lhs, rhs, opts, bufnr)
end
-- set a key mapping for command-line mode
_G.cnoremap = function(lhs, rhs, opts, bufnr)
  keymapper('c', lhs, rhs, opts, bufnr)
end
-- set a key mapping for terminal mode
_G.tnoremap = function(lhs, rhs, opts, bufnr)
  keymapper('t', lhs, rhs, opts, bufnr)
end
-- set a key mapping for operator-pending mode
_G.onoremap = function(lhs, rhs, opts, bufnr)
  keymapper('o', lhs, rhs, opts, bufnr)
end
-- set a key mapping for insert and command-line mode
_G.icnoremap = function(lhs, rhs, opts, bufnr)
  keymapper('!', lhs, rhs, opts, bufnr)
end

-- toggle two windows between vertical and horizontal splits
_G.rotate_windows = function()
  buffers_list = nv.exec('buffers', true)
  for match in buffers_list:gmatch '.*\n' do
    -- TODO: extract the buffer info 'a' for all active buffers and save it
    print(match)
  end
end

