-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set by LazyVim:
-- see (1) https://www.lazyvim.org/keymaps
--     (2) https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local Util = require("lazyvim.util")

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
keymap("n", "n", "nzzzv") -- next
keymap("n", "<C-d>", "<C-d>zz") -- halfpage down
-- keep cursor in position when joining
keymap("n", "J", "mzJ`z")
keymap("v", "J", "mzJ`z")
-- duplicate line(s) with Alt+d
keymap("i", "<A-d>", "<Esc>yypi", { desc = "duplicate line(s)" })
keymap("n", "<A-d>", "<Esc>yyp", { desc = "duplicate line(s)" })
keymap("v", "<A-d>", "oYPgv<Esc>", { desc = "duplicate line(s)" })
-- move line(s) with Alt+Shift+jk
keymap("n", "<A-S-j>", ":m .+1<CR>==", { desc = "move line(s)" })
keymap("n", "<A-S-k>", ":m .-2<CR>==", { desc = "move line(s)" })
keymap("i", "<A-S-j>", "<Esc>:m .+1<CR>==gi", { desc = "move line(s)" })
keymap("i", "<A-S-k>", "<Esc>:m .-2<CR>==gi", { desc = "move line(s)" })
keymap("v", "<A-S-j>", ":m '>+1<CR>gv=gv", { desc = "move line(s)" })
keymap("v", "<A-S-k>", ":m '<-2<CR>gv=gv", { desc = "move line(s)" })


--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
-- tmux-navigator
keymap("n", "<C-h>", ":NvimTmuxNavigateLeft<CR>", { desc = "Go to left window (tmux-aware)", remap = true })
keymap("n", "<C-j>", ":NvimTmuxNavigateDown<CR>", { desc = "Go to lower window (tmux-aware)", remap = true })
keymap("n", "<C-k>", ":NvimTmuxNavigateUp<CR>", { desc = "Go to upper window (tmux-aware)", remap = true })
keymap("n", "<C-l>", ":NvimTmuxNavigateRight<CR>", { desc = "Go to right window (tmux-aware)", remap = true })

--------------------------------------------------------------------------------
-- TUI applications
--------------------------------------------------------------------------------
-- gitui
keymap("n", "<leader>gu", function() Util.float_term({ "gitui" }, { cwd = Util.get_root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Gitui" })

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
