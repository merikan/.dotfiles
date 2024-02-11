-- vim.lsp.set_log_level("debug")

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local o = vim.opt
local g = vim.g

--------------------------------------------------------------------------------
-- Core
--------------------------------------------------------------------------------
o.clipboard:prepend { "unnamed", "unnamedplus" } -- use system buffer (cross-platform)
o.fileencoding = "utf-8" -- the encoding written to a file
o.mouse = "a" -- allow the mouse to be used in neovim
o.autoread = true -- automatically reload a file
g.autoformat = false -- disable LazyVim auto format

--------------------------------------------------------------------------------
-- Display
--------------------------------------------------------------------------------
o.termguicolors = true -- set term gui colors (most terminals support this)
o.splitbelow = true -- force all horizontal splits to go below current window
o.splitright = true -- force all vertical splits to go to the right of current window
o.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
o.updatetime = 300 -- faster completion (4000ms default)
o.laststatus = 3 -- only the last window will always have a status line
o.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
--? vim.opt.showbreak     = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
o.pumheight = 10 -- pop up menu height
o.showmode = false -- we don't need to see things like -- INSERT -- anymore
o.showtabline = 0 -- always show tabs
o.showcmd = false -- hide (partial) command in the last line of the screen (for performance)
o.cmdheight = 1 -- more space in the neovim command line for displaying messages
o.shortmess:append("c") -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
-- Font
o.guifont = "JetBrainsMono Nerd Font"

--------------------------------------------------------------------------------
-- Lines
--------------------------------------------------------------------------------
o.number = true -- set numbered lines
o.numberwidth = 4 -- minimal number of columns to use for the line number {default 4}
o.relativenumber = true -- use relative number
o.cursorline = true -- highlight the current line
o.scrolloff = 0 -- Lines of context

o.expandtab = true -- convert tabs to spaces
o.shiftwidth = 2 -- the number of spaces inserted for each indentation
o.tabstop = 2 -- insert 2 spaces for a tab
o.smartindent = true -- make indenting smarter again
o.ruler = false -- hide the line and column number of the cursor position
o.wrap = false -- do not wrap long lines
o.fillchars.eob = " " -- show empty lines at the end of a buffer as ` ` {default `~`}
o.whichwrap:append("<,>,[,],h,l") -- keys allowed to move to the previous/next line when the beginning/end of line is reached
o.iskeyword:append("-") -- treats words with `-` as single words

o.conceallevel = 0 -- so that `` is visible in markdown files
o.list = true -- :set list, :set nolist
o.listchars:append("trail:•")
o.listchars:append("eol:↴")
o.listchars:append("tab:» ")
o.listchars:append("extends:❯")
o.listchars:append("precedes:❮")
o.listchars:append("nbsp:_")
o.listchars:append("space:.")

--------------------------------------------------------------------------------
-- Search and Complelete
--------------------------------------------------------------------------------
o.incsearch = true -- use incremental search (nvim default)
o.hlsearch = true -- highlight all matches on previous search pattern
o.ignorecase = true -- ignore case in search patterns
o.smartcase = true -- with ignorecase to force case match if upper

o.completeopt = "menuone,noinsert,noselect"

--------------------------------------------------------------------------------
-- Backup / Undo / Swap
--------------------------------------------------------------------------------
o.backup = false -- creates a backup file
o.undofile = true -- enable persistent undo
o.swapfile = false -- creates a swapfile
o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

--------------------------------------------------------------------------------
-- Other
--------------------------------------------------------------------------------
o.path:append { "**" } -- gf jump to file under cursor, CTRL-^ to jump back
o.grepprg = "rg --vimgrep --smart-case --follow" -- use ripgrep instead of grep

if vim.g.neovide then
  vim.g.neovide_cursor_trail_legnth = 0
  vim.g.neovide_cursor_animation_length = 0
  --vim.o.guifont = "Jetbrains Mono"
end

