local o = vim.opt
-- local ol = vim.opt_local
-- local wo = vim.wo
-- local bo = vim.bo
local cmd = vim.cmd

-- set leader key(s)
keymap('n', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ","

cmd('syntax on')                        -- enable syntax highlighing
o.errorbells = false                    -- no sound effects

o.termguicolors = true                  -- set true colors
o.ruler = true                          -- show the cursor position all the time
o.cursorline = true                     -- enable highlighting of the current line
-- make line nicer just like miyakogi/conoline.vim
cmd('hi cursorline cterm=none term=none')
cmd('autocmd WinEnter * setlocal cursorline')
cmd('autocmd WinLeave * setlocal nocursorline')
cmd('highlight CursorLine guibg=#303000 ctermbg=234')
o.number = true                         -- show line numbers
o.relativenumber = true                 -- use relative number
o.laststatus = 2                        -- always display the status line
o.background = 'dark'                   -- tell vim what the background color looks like
o.incsearch = true                      -- use incremental search (nvim default)
o.mouse = 'a'                           -- enable mouse
-- o.pumheight = 10                     -- Makes popup menu smaller
o.cmdheight = 2                         -- more space for displaying messages
o.conceallevel = 0                      -- so that I can see `` in markdown file

o.tabstop = 2                           -- number of spaces for a tab
o.softtabstop = 2
o.shiftwidth = 2                        -- number of space characters inserted for indentation
o.smarttab = true                       -- makes tabbing smarter will realize you have 2 vs 4
o.expandtab = true                      -- converts tabs to spaces
o.smartindent = true                    -- makes indenting smart
o.autoindent = true                     -- good auto indent
o.showtabline = 2                       -- always show tabs
o.wrap = false                          -- display long lines as just one line
cmd('set whichwrap+=<,>,[,],h,l')       -- automatically wrap left and right
-- o.whichwrap:append({"<",">","[","]","h","l"}) -- automatically wrap left and right

o.splitbelow = true                     -- horizontal split will be below
o.splitright = true                     -- vertical split will be to the righ

o.iskeyword:append('-')                 -- treat dash separated words as a word text object
cmd('set formatoptions-=cro')             -- stop newline continution of comments
-- o.formatoptions:remove({"c","r","o"}) -- stop newline continution of comments
-- o.list = true
-- o.listchars:append("eol:↴")

o.backup = false                        -- skip backup
o.writebackup = false                   -- skip backup
o.undodir = '~/.local/share/nvim/undodir' -- use undo directory

cmd('set shortmess+=c')                   -- don't pass messages to |ins-completion-menu|.
-- opt.shortmess:append( {"c"} )             -- don't pass messages to |ins-completion-menu|.
o.signcolumn = 'yes'                    -- always show the signcolumn, otherwise it would shift the text each time
o.updatetime = 300                      -- faster completion
-- opt.timeoutlen = 150                      -- shorter timeout (default 1000 ms
o.hidden = true                         -- allow switching edited buffers without saving
o.clipboard:prepend({"unnamed","unnamedplus"}) -- use system buffer (cross-platform)
o.path:append({"**"})                       -- gf jump to file under cursor, CTRL-^ to jump back
o.guifont = "JetBrainsMono Nerd Font"
o.grepprg = "rg --vimgrep --smart-case --follow" -- use ripgrep instead of grep
