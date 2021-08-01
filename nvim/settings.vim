syntax on                               " enable syntax highlighing
set noerrorbells                        " no sound effects

set termguicolors                       " set true colors
set ruler              	                " show the cursor position all the time
set cursorline                          " enable highlighting of the current line
hi cursorline cterm=none term=none      " make line nicer (also see miyakogi/conoline.vim)
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303000 ctermbg=234
set number                              " show line numbers
set relativenumber                      " use relative number
set laststatus=2                        " always display the status line
set background=dark                     " tell vim what the background color looks like
set incsearch                           " use incremental search (nvim default)
set mouse=a                             " enable mouse 
"set pumheight=10                        " Makes popup menu smaller
set cmdheight=2                         " more space for displaying messages
"set conceallevel=0                      " so that I can see `` in markdown files

set tabstop=2                           " number of spaces for a tab
set softtabstop=2
set shiftwidth=2                        " number of space characters inserted for indentation
set smarttab                            " makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " converts tabs to spaces
set smartindent                         " makes indenting smart
set autoindent                          " good auto indent
set showtabline=2                       " always show tabs
set nowrap                              " display long lines as just one line
set whichwrap+=<,>,[,],h,l              " automatically wrap left and right
set splitbelow                          " horizontal split will be below
set splitright                          " vertical split will be to the right

set iskeyword+=-                      	" treat dash separated words as a word text object
set formatoptions-=cro                  " stop newline continution of comments

set nobackup                            " skip backup (recommended by coc)
set nowritebackup                       " skip backup(recommended by coc)
set undodir=~/.local/share/nvim/undodir " use undo directory
set shortmess+=c                        " don't pass messages to |ins-completion-menu|.
set signcolumn=yes                      " always show the signcolumn, otherwise it would shift the text each time
set updatetime=300                      " faster completion
set timeoutlen=150                      " shorter timeout (default 1000 ms)

set hidden                              " allow switching edited buffers without saving
set clipboard^=unnamed,unnamedplus      " use system buffer (cross-platform)
set path+=**                            " gf jump to file under cursor, CTRL-^ to jump back
set guifont=JetBrainsMono\ Nerd\ Font
set grepprg=rg\ --vimgrep\ --smart-case\ --follow " use ripgrep instead of grep