-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set by LazyVim:
-- see (1) https://www.lazyvim.org/keymaps (2) https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local Util = require("lazyvim.util")

-- My additional keymaps

-- make Y behave like C and D
keymap('n', 'Y', 'y$')
-- delete without yanking
keymap('n', '<leader>d', '"_d')
keymap('v', '<leader>d', '"_d')
-- paste without yanking
keymap('v', '<leader>p', '"_dP')
-- reselect pasted text
keymap('n', 'gp', '[v`]')

-- Don't yank on delete char
keymap("n", "x", '"_x')
keymap("n", "X", '"_X')
keymap("v", "x", '"_x')
keymap("v", "X", '"_X')

-- Don't yank on visual paste
keymap("v", "p", '"_dP')

-- make command+v (paste) work in Neovide
if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1
  keymap('', '<D-v>', '+p<CR>')
  keymap('!', '<D-v>', '<C-R>+')
  keymap('t', '<D-v>', '<C-R>+')
  keymap('n', 'N', 'Nzzzv') --  previous
  keymap('n', '<C-u>', '<C-u>zz') -- halfpage up
  keymap('v', '<D-v>', '<C-R>+')
end
-- keep current line centered when jumping
keymap('n', 'n', 'nzzzv') -- next
keymap('n', '<C-d>', '<C-d>zz') -- halgpage down
-- keep cursor in position when joining
keymap('n', 'J', 'mzJ`z')
keymap('v', 'J', 'mzJ`z')
-- duplicate line(s) with Alt+d
keymap('i','<A-d>','<Esc>yypi')
keymap('n','<A-d>','<Esc>yyp')
keymap('v','<A-d>', 'oYPgv<Esc>')
-- move line(s) with Alt+Shift+jk
keymap('n', '<A-S-j>', ':m .+1<CR>==')
keymap('n', '<A-S-k>', ':m .-2<CR>==')
keymap('i', '<A-S-j>', '<Esc>:m .+1<CR>==gi')
keymap('i', '<A-S-k>', '<Esc>:m .-2<CR>==gi')
keymap('v', '<A-S-j>', ':m \'>+1<CR>gv=gv')
keymap('v', '<A-S-k>', ':m \'<-2<CR>gv=gv')

-- gitui
local gitui = function() Util.float_term(nil, { cwd = Util.get_root() }) end
keymap("n", "<leader>gu", gitui, { desc = "Gitui (root dir)" })
