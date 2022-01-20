

-- vim.g.mapleader = " "
-- -- vim.api.nvim_set_keymap('n', 'gf', ':e <cfile><CR>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<M-Up>', '<cmd>resize -5<cr>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<M-Down>', '<cmd>resize +5<cr>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<M-Left>', '<cmd>vert resize -10<cr>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<M-Right>', '<cmd>vert resize +10<cr>', {noremap = true})

-- -- go back to the last file
-- vim.api.nvim_set_keymap('n', '<c-l>', '<c-^>', {noremap = true})

-- vim.api.nvim_set_keymap('n', '<leader>nh', '<CMD>nohlsearch<CR>', {noremap = true})

-- -- quickfix list commands
-- vim.api.nvim_set_keymap('n', '<leader>cc', '<CMD>cc<CR>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<leader>n', '<CMD>cnext<CR>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<leader>p', '<CMD>cprevious<CR>', {noremap = true})


-- clear highlightning with C-l or double Esc
keymap('n', '<silent> <C-l>', ':nohl<CR><C-l>')
-- clear highlighting on escape in normal mode
keymap('n', '<esc>', ':noh<return><return>')
-- map hh top escape b/c it's faster to reach and type
keymap('i', 'hh', '<ESC>')
-- toggle cursorline and cursorcolumn
keymap('n', '<Leader>tc',':set cursorline! cursorcolumn!<CR>')
-- Alternate way to save
keymap('n', '<C-s>', ':w<CR>')
-- Alternate way to quit
keymap('n', '<C-Q>', ':q!<CR>')

-- make Y behave like C and D
keymap('n', 'Y', 'y$')
-- delete without yanking
keymap('n', '<leader>d', '"_d')
keymap('v', '<leader>d', '"_d')
-- paste without yanking
keymap('v', '<leader>p', '"_dP')
-- reselect pasted text
keymap('n', 'gp', '[v`]')
-- keep current line centered when jumping
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
-- keep cursor in position when joining
keymap('n', 'J', 'mzJ`z')
keymap('v', 'J', 'mzJ`z')
-- repeatable indenting
keymap('n', '>', 'V><Esc>')
keymap('n', '<', 'V<<Esc>')
keymap('v', '>', '>gv')
keymap('v', '<', '<gv')
-- duplicate line(s) with Alt+d
if vim.fn.has('mac') then -- option != alt
  keymap('i', '∂','<Esc>yypi')
  keymap('n','∂','<Esc>yyp')
  keymap('v','∂', 'oYPgv<Esc>')
else
  keymap('i', '<A-d>','<Esc>yypi')
  keymap('n','<A-d>','<Esc>yyp')
  keymap('v','<A-d>', 'oYPgv<Esc>')
end
-- move lines Alt+hjkl
if vim.fn.has('mac') then -- because option != alt
  -- Option-key is not Alt-key
  -- > US/ANSI keyboard (see alacritty.yaml)
  keymap('n', '∆', ':m .+1<CR>==')
  keymap('n', '˚', ':m .-2<CR>==')
  keymap('i', '∆', '<Esc>:m .+1<CR>==gi')
  keymap('i', '˚', '<Esc>:m .-2<CR>==gi')
  keymap('v', '∆', ':m \'>+1<CR>gv=gv')
  keymap('v', '˚', ':m \'<-2<CR>gv=gv')
else
  keymap('n', '<A-j>', ':m .+1<CR>==')
  keymap('n', '<A-k>', ':m .-2<CR>==')
  keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
  keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
  keymap('v', '<A-j>', ':m \'>+1<CR>gv=gv')
  keymap('v', '<A-k>', ':m \'<-2<CR>gv=gv')
end

-- buffers navigation
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")
keymap('n', '<C-tab>', ':bnext<CR>')
keymap('n', '<C-S-tab>', ':bprevious<CR>')
-- window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")
-- Terminal window navigation
keymap('t', '<C-h>', '<C-\\><C-N><C-w>h')
keymap('t', '<C-j>', '<C-\\><C-N><C-w>j')
keymap('t', '<C-k>', '<C-\\><C-N><C-w>k')
keymap('t', '<C-l>', '<C-\\><C-N><C-w>l')
keymap('t', '<Esc>', '<C-\\><C-n>')


-- ====================================================
-- " map     : root of all recursive mappings
-- " noremap : no recursive map
-- " {m}{nore}map
-- " Mode letters:
-- " n: normal only
-- " v: visual and select
-- " o: operator-pending
-- " x: visual only
-- " s: select only
-- " i: insert
-- " c: command-line
-- " t: terminal window
-- " l: insert, command-line, regexp-search (and others. Collectively called "Lang-Arg" pseudo-mode)
