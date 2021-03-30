" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plugged'))
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')  
  if exists('g:vscode')
    " Easy motion for VSCode
    Plug 'asvetliakov/vim-easymotion'
    "sPlug 'ChristianChiarulli/vscode-easymotion'
    Plug 'machakann/vim-highlightedyank'
  else
    " TMux - Vim integration
    Plug 'christoomey/vim-tmux-navigator'
    " Start Screen
    Plug 'mhinz/vim-startify'
    " fzf fuzzy finder
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    " Syntax Higlight  
    Plug 'sheerun/vim-polyglot'
    " consistent coding styles
    Plug 'editorconfig/editorconfig-vim'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " Colorizer
    Plug 'norcalli/nvim-colorizer.lua'
    " Intellisense
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " git wrapper for vim
    Plug 'tpope/vim-fugitive'
    " shows a git diff in the sign column.
    Plug 'airblade/vim-gitgutter'
    " an awesome git commit browser
    Plug 'junegunn/gv.vim'
    " cwd to project root
    "Plug 'airblade/vim-rooter'
    " add some icons 
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'ryanoasis/vim-devicons'
    " golang development
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    " rust development
    Plug 'rust-lang/rust.vim'
    " lua language
    Plug 'tjdevries/nlua.nvim'
    " better auto-completion UX experience for builtin LSP.
    Plug 'nvim-lua/completion-nvim'
    " better Lua syntax highlighting
    Plug 'euclidianAce/BetterLua.vim'
    " undo time travel
    Plug 'mbbill/undotree'
    " See what keys do like in emacs
    Plug 'liuchengxu/vim-which-key'
    " Sneak
    " Plug 'justinmk/vim-sneak'
    " File Explorer
    "Plug 'scrooloose/NERDTree'
    "Plug 'mbbill/undotree'
    Plug 'preservim/nerdtree'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'Xuyuanp/nerdtree-git-plugin' 
    Plug 'ryanoasis/vim-devicons' 
    " ==== Color schemes
    Plug 'doums/darcula'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'chriskempson/base16-vim'
    Plug 'morhetz/gruvbox'
    Plug 'joshdick/onedark.vim'
  endif
call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif