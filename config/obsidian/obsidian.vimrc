" https://github.com/esm7/obsidian-vimrc-support"

set clipboard=unnamed

" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk
" Quickly remove search highlights
nmap <F9> :nohl
" quick escape"
imap jj <Esc>

" Yank to system clipboard
set clipboard=unnamed

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward

" Emulate Folding https://vimhelp.org/fold.txt.html#fold-commands
exmap togglefold obcommand editor:toggle-fold
nmap zo :togglefold
nmap zc :togglefold
nmap za :togglefold

exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall

exmap foldall obcommand editor:fold-all
nmap zM :foldall

" Emulate Tab Switching https://vimhelp.org/tabpage.txt.html#gt
" requires Cycle Through Panes Plugins https://obsidian.md/plugins?id=cycle-through-panes
exmap tabnext obcommand cycle-through-panes:cycle-through-panes
nmap L :tabnext
exmap tabprev obcommand cycle-through-panes:cycle-through-panes-reverse
nmap H :tabprev

" Maps pasteinto to Alt-p
" https://github.com/esm7/obsidian-vimrc-support#inserting-linkshyperlinks-with-pasteinto
map <A-p> :pasteinto
