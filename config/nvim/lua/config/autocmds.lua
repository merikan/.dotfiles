-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- show cursorline only in active window, restoring each window's own setting
-- https://github.com/TheLeoP/nvim-config/blob/master/plugin/autocmd.lua
vim.api.nvim_create_autocmd("WinEnter", {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		local win = vim.api.nvim_get_current_win()
		-- schedule to keep event order when switching windows quickly (e.g. <c-w>t)
		vim.schedule(function()
			if not vim.api.nvim_win_is_valid(win) then
				return
			end
			if not vim.w[win].cached_cursorline then
				return
			end
			vim.wo[win].cursorline = vim.w[win].cached_cursorline
			vim.w[win].cached_cursorline = nil
		end)
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = "active_cursorline",
	callback = function()
		local win = vim.api.nvim_get_current_win()
		-- schedule so a new tab copies window options before cursorline is disabled
		vim.schedule(function()
			if not vim.api.nvim_win_is_valid(win) then
				return
			end
			vim.w[win].cached_cursorline = vim.wo[win].cursorline
			vim.wo[win].cursorline = false
		end)
	end,
})
