-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set by LazyVim:
-- see (1) https://www.lazyvim.org/keymaps
--     (2) https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local lazyvim_util = require("lazyvim.util")
local set = vim.keymap.set
local del = vim.keymap.del
-- Delete LazyVim default bindings for meta information
del("n", "<leader>l")
del("n", "<leader>L")

set("n", "<leader>;P", "<cmd>Mason<CR>", { desc = "Package Manager - [Mason]" })
set("n", "<leader>;p", "<cmd>Lazy<CR>", { desc = "Plugin Manager - [LazyVim]" })
set("n", "<leader>;e", "<cmd>LazyExtras<CR>", { desc = "Extras Manager - [LazyVim]" })
set("n", "<leader>;i", "<cmd>LspInfo<CR>", { desc = "Lsp Info" })
set("n", "<leader>;c", lazyvim_util.news.changelog, { desc = "Changelog [LazyVim]" })
set("n", "<leader>;r", lazyvim_util.root.info, { desc = "Root Info [LazyVim]" })
set("n", "<leader>;M", vim.cmd.messages, { desc = "Display messages" })
-- My additional keymaps

-- make Y behave like C and D
keymap("n", "Y", "y$", { desc = "Y like C and D" })
-- paste without yank
keymap("v", "p", '"_dP', { desc = "paste without yank" })
-- delete without yanking
keymap({ "n", "x" }, "<leader>d", '"_d', { desc = "delete without yank" })
-- delete char without yanking
keymap({ "n", "v" }, "x", '"_x', { desc = "delete char without yank" })
keymap({ "n", "v" }, "X", '"_X', { desc = "delete char without yank" })
-- reselect pasted text
keymap("n", "gp", "[v`]", { desc = "reselect pasted text" })

-- make command+v (paste) work in Neovide
if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1
  keymap("", "<D-v>", "+p<CR>")
  keymap("!", "<D-v>", "<C-R>+")
  keymap("t", "<D-v>", "<C-R>+")
  keymap("n", "N", "Nzzzv") --  previous
  keymap("n", "<C-u>", "<C-u>zz") -- halfpage up
  keymap("v", "<D-v>", "<C-R>+")
end
-- keep current line centered when jumping
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Halfpage down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Halfpage up" })
-- keep cursor in position when joining
keymap({ "n", "v" }, "J", "mzJ`z", { desc = "Join lines" })
-- duplicate line(s) with Alt+d
keymap("i", "<A-d>", "<Esc>yypi", { desc = "Duplicate line(s)" })
keymap("n", "<A-d>", "<Esc>yyp", { desc = "Duplicate line(s)" })
keymap("v", "<A-d>", "oYPgv<Esc>", { desc = "Duplicate line(s)" })
-- move line(s) with Alt+Shift+jk
keymap("n", "<A-S-j>", ":m .+1<CR>==", { desc = "Move line(s) down" })
keymap("n", "<A-S-k>", ":m .-2<CR>==", { desc = "Move line(s) up" })
keymap("i", "<A-S-j>", "<Esc>:m .+1<CR>==gi", { desc = "move line(s) down" })
keymap("i", "<A-S-k>", "<Esc>:m .-2<CR>==gi", { desc = "move line(s) up" })
keymap("v", "<A-S-j>", ":m '>+1<CR>gv=gv", { desc = "move line(s) down" })
keymap("v", "<A-S-k>", ":m '<-2<CR>gv=gv", { desc = "move line(s) up" })

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
-- tmux-navigator
if vim.env.TMUX ~= nil then
  keymap("n", "<C-h>", ":NvimTmuxNavigateLeft<CR>", { desc = "Go to left window (tmux-aware)", remap = true })
  keymap("n", "<C-j>", ":NvimTmuxNavigateDown<CR>", { desc = "Go to lower window (tmux-aware)", remap = true })
  keymap("n", "<C-k>", ":NvimTmuxNavigateUp<CR>", { desc = "Go to upper window (tmux-aware)", remap = true })
  keymap("n", "<C-l>", ":NvimTmuxNavigateRight<CR>", { desc = "Go to right window (tmux-aware)", remap = true })
end

--------------------------------------------------------------------------------
-- TUI applications
--------------------------------------------------------------------------------
-- gitui
keymap("n", "<leader>gu", function()
  lazyvim_util.float_term({ "gitui" }, { cwd = lazyvim_util.get_root(), esc_esc = false, ctrl_hjkl = false })
end, { desc = "Gitui" })

-- ====================================================
--  map     : root of all recursive mappings
--  noremap : no recursive map
--  {m}{nore}map
--
--  Mode letters:
--    n: normal only
--    v: visual and select
--    o: operator-pending
--    x: visual only
--    s: select only
--    i: insert
--    c: command-line
--    t: terminal window
--    l: insert, command-line, regexp-search (and others. Collectively called "Lang-Arg" pseudo-mode)
