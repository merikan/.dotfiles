
-- set leader key(s)
keymap('n', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ","

-- clear highlightning with C-l or double Esc
keymap('n', '<silent> <C-l>', ':nohl<CR><C-l>')
-- clear highlighting on escape in normal mode
keymap('n', '<esc>', ':noh<CR>')
-- map hh top escape b/c it's faster to reach and type
keymap('i', 'hh', '<ESC>')
-- toggle cursorline and cursorcolumn
keymap('n', '<Leader>tc',':set cursorline! cursorcolumn!<CR>')
-- Alternate way to save
keymap('i', '<C-s>', '<ESC>:w<CR>a')
keymap('n', '<C-s>', ':w<CR>')
-- Alternate way to quit
keymap('i', '<C-Q>', '<ESC>:q!<CR>')
keymap('n', '<C-Q>', ':q!<CR>')

-- clear highlightning with C-l or double Esc
keymap('n', '<silent> <C-l>', ':nohl<CR><C-l>')
-- clear highlighting on escape in normal mode
keymap('n', '<esc>', ':noh<CR>')
-- map hh top escape b/c it's faster to reach and type
keymap('i', 'hh', '<ESC>')
-- toggle cursorline and cursorcolumn
keymap('n', '<Leader>tc',':set cursorline! cursorcolumn!<CR>')

-- make Y behave like C and D
keymap('n', 'Y', 'y$')
-- delete without yanking
keymap('n', '<leader>d', '"_d')
keymap('v', '<leader>d', '"_d')
-- paste without yanking
keymap('v', '<leader>p', '"_dP')
-- reselect pasted text
keymap('n', 'gp', '[v`]')
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
-- repeatable indenting
keymap('n', '>', 'V><Esc>')
keymap('n', '<', 'V<<Esc>')
keymap('v', '>', '>gv')
keymap('v', '<', '<gv')
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
-- buffers navigation
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")
keymap('n', '<C-tab>', ':bnext<CR>')
keymap('n', '<C-S-tab>', ':bprevious<CR>')
-- window navigation (disbled since we are using tmux plugin)
-- keymap("n", "<C-h>", "<C-w>h")
-- keymap("n", "<C-j>", "<C-w>j")
-- keymap("n", "<C-k>", "<C-w>k")
-- keymap("n", "<C-l>", "<C-w>l")
-- Terminal window navigation
keymap('t', '<C-h>', '<C-\\><C-N><C-w>h')
keymap('t', '<C-j>', '<C-\\><C-N><C-w>j')
keymap('t', '<C-k>', '<C-\\><C-N><C-w>k')
keymap('t', '<C-l>', '<C-\\><C-N><C-w>l')
keymap('t', '<Esc>', '<C-\\><C-n>')

-- Diagnostics
-- keymap('n', '<leader>qq', toggle_diagnostics)
-- keymap('n', '<leader>qq', toggle_diagnostics_loclist)
-- keymap('n', '<leader>qp', vim.diagnostic.goto_prev)
-- keymap('n', '<leader>qn', vim.diagnostic.goto_next)
-- keymap('n', '<leader>qL', vim.diagnostic.setloclist)
-- keymap('n', '<leader>ql', vim.diagnostic.setqflist)
-- keymap('n', '<leader>qe', vim.diagnostic.open_float)

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope
keymap("n", "<leader>T", ":Telescope<CR>")
keymap("n", "<leader>fb", ":Telescope file_browser<CR>")
keymap("n", "<leader>fB", ":Telescope buffers<CR>")
keymap("n", "<leader>ff", ":Telescope find_files<CR>")
keymap("n", "<leader>fg", ":Telescope live_grep<CR>")
keymap("n", "<leader>fG", ":Telescope git_files<CR>")
keymap("n", "<leader>fj", ":Telescope jumplist<CR>")
keymap("n", "<leader>fn", "<cmd>lua require('telescope').extensions.notify.notify()<CR>")
keymap("n", "<leader>fp", ":Telescope projects<CR>")
keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>")
keymap("n", "<leader>fS", ":Telescope lsp_workspace_symbols<CR>")

-- trouble
keymap('n', '<Leader>tt', '<Cmd>TroubleToggle<CR>', opts)
-- Git
keymap("n", "<leader>gui", "<cmd>lua _GITUI_TOGGLE()<CR>")
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>")

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>")
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- bufdelete.nvim
keymap("n", "<leader>q", "<cmd>Bdelete<CR>")
-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>")
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>")
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>")
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>")
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>")

-- Illuminate
keymap('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>')
keymap('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>')



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


