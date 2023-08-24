local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

--Highlight yanked text for a short time
au('TextYankPost', {
  -- group = ag('yank_highlight', {}),
  -- pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup='Visual', timeout=300 }
  end,
})


-- autocommand to keep a history of lockfiles
-- https://github.com/folke/lazy.nvim/issues/234
vim.api.nvim_create_autocmd("User", {
  pattern = { "LazySync", "LazyUpdate"},
  callback = function()
    local uv = vim.loop
    local NUM_BACKUPS = 50
    local config_dir = vim.fn.stdpath "config"
    local LOCKFILES_DIR = string.format("%s/lockfiles/", config_dir)
    local cache_dir = vim.fn.stdpath "cache"
    local LOCKFILES_BACKUP_DIR = string.format("%s/lazy/lockfiles/", cache_dir)

    -- create if not existing
    if not uv.fs_stat(LOCKFILES_DIR) then
      uv.fs_mkdir(LOCKFILES_DIR, 448)
    end
    if not uv.fs_stat(LOCKFILES_BACKUP_DIR) then
      uv.fs_mkdir(LOCKFILES_BACKUP_DIR, 448)
    end

    local lockfile = require("lazy.core.config").options.lockfile
    if uv.fs_stat(lockfile) then
      -- create "%Y%m%d_%H:%M:%s_lazy-lock.json" in lockfile folder
      local filename = string.format("%s_lazy-lock.json", os.date "%Y%m%d_%H:%M:%S")
      local backup_lockfile = string.format("%s/%s", LOCKFILES_BACKUP_DIR, filename)
      local success = uv.fs_copyfile(lockfile, backup_lockfile)
      if success then
        -- clean up backups in excess of `num_backups`
        local iter_dir = uv.fs_scandir(LOCKFILES_BACKUP_DIR)
        if iter_dir then
          local suffix = "lazy-lock.json"
          local backups = {}
          while true do
            local name = uv.fs_scandir_next(iter_dir)
            -- make sure we are deleting lockfiles
            if name and name:sub(- #suffix, -1) == suffix then
              table.insert(backups, string.format("%s/%s", LOCKFILES_BACKUP_DIR, name))
            end
            if name == nil then
              break
            end
          end
          if not vim.tbl_isempty(backups) and #backups > NUM_BACKUPS then
            -- remove the lockfiles
            for _ = 1, #backups - NUM_BACKUPS do
              uv.fs_unlink(table.remove(backups, 1))
            end
          end
        end
      end
      vim.notify(string.format("Backed up to %s", filename), vim.log.levels.INFO, { title = "lazy.nvim" })
    end
  end,
})
-- au({ "FileType" }, {
-- 	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
-- 	callback = function()
-- 		vim.cmd([[
--       nnoremap <silent> <buffer> q :close<CR> 
--       set nobuflisted 
--     ]])
-- 	end,
-- })
--
-- au({ "FileType" }, {
-- 	pattern = { "gitcommit"},
-- 	callback = function()
-- 		vim.opt_local.wrap = true
-- 		vim.opt_local.spell = true
-- 	end,
-- })
--
-- au({ "FileType" }, {
-- 	pattern = { "markdown" },
-- 	callback = function()
-- 		vim.opt_local.wrap = true
-- 		vim.opt_local.spell = true
-- 	end,
-- })
--
--
-- vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")
-- -- vim.api.nvim_create_autocmd({ "BufEnter" }, {
-- --   callback = function()
-- --     vim.cmd [[
-- --       if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
-- --     ]]
-- --   end,
-- -- })
--
-- au({ "VimResized" }, {
-- 	callback = function()
-- 		vim.cmd("tabdo wincmd =")
-- 	end,
-- })
--
-- au({ "CmdWinEnter" }, {
-- 	callback = function()
-- 		vim.cmd("quit")
-- 	end,
-- })
-- au({ "BufWinEnter" }, {
-- 	callback = function()
-- 		vim.cmd("set formatoptions-=cro")
-- 	end,
-- })
--
-- au({ "BufWritePost" }, {
-- 	pattern = { "*.java" },
-- 	callback = function()
-- 		vim.lsp.codelens.refresh()
-- 	end,
-- })
--
-- au({ "VimEnter" }, {
-- 	callback = function()
-- 		vim.cmd("hi link illuminatedWord LspReferenceText")
-- 	end,
-- })
--
-- -- pause illuminate if large file
-- au({ "BufWinEnter" }, {
-- 	callback = function()
-- 	local line_count = vim.api.nvim_buf_line_count(0)
-- 		if line_count >= 5000 then
-- 			vim.cmd("IlluminatePauseBuf")
-- 		end
-- 	end,
-- })
--
