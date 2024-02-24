-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set by LazyVim:
-- see (1) https://www.lazyvim.org/keymaps
--     (2) https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local util = require("lazyvim.util")
local set = vim.keymap.set
local del = vim.keymap.del
-- Delete LazyVim default bindings for meta information
del("n", "<leader>l")
del("n", "<leader>L")

set("n", "<leader>;P", "<cmd>Mason<CR>", { desc = "Package Manager - [Mason]" })
set("n", "<leader>;p", "<cmd>Lazy<CR>", { desc = "Plugin Manager - [LazyVim]" })
set("n", "<leader>;e", "<cmd>LazyExtras<CR>", { desc = "Extras Manager - [LazyVim]" })
set("n", "<leader>;i", "<cmd>LspInfo<CR>", { desc = "Lsp Info" })
set("n", "<leader>;c", util.news.changelog, { desc = "Changelog [LazyVim]" })
set("n", "<leader>;r", util.root.info, { desc = "Root Info [LazyVim]" })
set("n", "<leader>;M", vim.cmd.messages, { desc = "Display messages" })

-- My additional keymaps

-- Previous end of word
keymap("n", "E", "ge", { desc = "Previous end of word" })
-- make Y behave like C and D
keymap("n", "Y", "y$", { desc = "Yank to end of line" })
-- paste without yank
keymap("v", "p", '"_dP', { desc = "Paste without yank" })
-- delete without yanking
keymap({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without yank" })
-- delete char without yanking
keymap({ "n", "v" }, "x", '"_x', { desc = "Delete char without yank" })
keymap({ "n", "v" }, "X", '"_X', { desc = "Delete char without yank" })
-- reselect pasted text
keymap("n", "gp", "[v`]", { desc = "Reselect pasted text" })

-- keep current line centered when jumping
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Halfpage down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Halfpage up" })
-- keep cursor in position when joining
keymap({ "n", "v" }, "J", "mzJ`z", { desc = "Join lines and keep position" })
-- duplicate line(s) with Alt+d
keymap("i", "<A-d>", "<Esc>yypi", { desc = "Duplicate line(s)" })
keymap("n", "<A-d>", "<Esc>yyp", { desc = "Duplicate line(s)" })
keymap("v", "<A-d>", "oYPgv<Esc>gv=gv", { desc = "Duplicate line(s)" })
-- move line(s) with Alt+Shift+jk
keymap("n", "<A-S-j>", ":m .+1<CR>==", { desc = "Move line(s) down" })
keymap("n", "<A-S-k>", ":m .-2<CR>==", { desc = "Move line(s) up" })
keymap("i", "<A-S-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line(s) down" })
keymap("i", "<A-S-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line(s) up" })
keymap("v", "<A-S-j>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
keymap("v", "<A-S-k>", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })

-- Save without formatting
keymap("n", "<A-s>", "<cmd>noautocmd w<CR>", { desc = "Save without formatting" })
-- Toggle background
-- stylua: ignore
keymap("n", "<leader>uB", function() util.toggle("background", false, { "light", "dark" }) end, { desc = "Toggle Background" })

-- write with sudo
keymap("c", "w!!", "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- make gx work again
if vim.fn.has('macunix') == 1 then
  keymap("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", { silent = true })
else
  keymap("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape('<cWORD>')<CR>", { silent = true })
end

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

-- grmagatti/goto-preview
local wk = require("which-key")
wk.register { ["<leader>gp"] = { name = "+preview" } }
-- stylua: ignore
keymap( "n", "<leader>gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", { desc = "Preview Definition" })
-- stylua: ignore
keymap( "n", "<leader>gpy", "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>", { desc = "Preview T[y]pe Definition" })
-- stylua: ignore
keymap( "n", "<leader>gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", { desc = "Preview Implementation" })
-- stylua: ignore
keymap( "n", "<leader>gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<cr>", { desc = "Preview Declaration" })
-- stylua: ignore
keymap("n", "<leader>gpc", "<cmd>lua require('goto-preview').close_all_win()<cr>", { desc = "Close All Preview Win" })
-- stylua: ignore
keymap( "n", "<leader>gpr", "<cmd>lua require('goto-preview').goto_preview_references()<cr>", { desc = "Preview References" })

-- stylua: ignore
keymap("n", "<leader>B", function() require("telescope.builtin").buffers { sort_mru = true, ignore_current_buffer = true, show_all_buffers = false, } { desc = "Switch Buffers" } end)
--------------------------------------------------------------------------------
-- TUI applications
--------------------------------------------------------------------------------
-- gitui
-- stylua: ignore
keymap("n", "<leader>gu", function() util.float_term({ "gitui" }, { cwd = util.get_root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Gitui" })

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
