" https://github.com/esm7/obsidian-vimrc-support"
" this plugin also provides the following motions/mappings by default:
"
" [[ and ]] to jump to the previous and next Markdown heading.
" zk and zj to move up and down while skipping folds.
" gl and gL to jump to the next and previous link.
" gf to open the link or file under the cursor (temporarily moving the cursor if necessary—e.g. if it's on the first square bracket of a [[Wikilink]]).

" Yank to system clipboard
set clipboard=unnamed
" unset to use as leader key
unmap <Space>

nnoremap Y y$ " Make Y behave like C and D

" navigate visual lines rather than logical ones
nnoremap j gj
nnoremap k gk
" nnoremap I g0i
" nnoremap A g$i
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

exmap tabnext obcommand workspace:next-tab
nmap gt :tabnext<CR>
nmap L :tabnext<CR>
nmap ]b :tabnext<CR>
exmap tabprev obcommand workspace:previous-tab
nmap gT :tabprev<CR>
nmap H :tabprev<CR>
nmap ]b :tabprev<CR>
" Quickly remove search highlights
nmap <F9> :nohl<CR>

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

" Emulate Folding https://vimhelp.org/fold.txt.html#fold-commands
exmap togglefold obcommand editor:toggle-fold
nmap zo :togglefold<CR>
nmap zc :togglefold<CR>
nmap za :togglefold<CR>

exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall<CR>
exmap foldall obcommand editor:fold-all
nmap zM :foldall<CR>

" Toggle left side bar
exmap toggleLeftSideBar obcommand app:toggle-left-sidebar
nmap <Space>e :toggleLeftSideBar<CR>
" close other buffers"
exmap closeOthers obcommand workspace:close-others
nmap <Space>bo :closeOthers<CR>
" use omnisearch to find files
exmap findFiles obcommand omnisearch:show-modal
nmap <Space><Space> :findFiles<CR>
nmap <Space>ff :findFiles<CR>
" Focus on global search input
exmap globalSearch obcommand global-search:open
nmap <Space>fw :globalSearch<CR>

" Maps pasteinto to Alt-p
" https://github.com/esm7/obsidian-vimrc-support#inserting-linkshyperlinks-with-pasteinto
map <A-p> :pasteinto<CR>

exmap followLink obcommand editor:follow-link
nmap gx :followLink<CR>
nmap gf :followLink<CR>

" create file
exmap newfile obcommand file-explorer:new-file
nmap <Space>fn :newfile<CR>
"rename file
exmap rename obcommand workspace:edit-file-title
nmap grn :rename<CR>
nmap <Space>cr :rename<CR>

" split windows
exmap vsplit obcommand workspace:split-vertical
nmap <C-w>v :vsplit<CR>
nmap <C-w>| :vsplit<CR>
exmap hsplit obcommand workspace:split-horizontal
nmap <C-w>h :hsplit<CR>
nmap <C-w>- :hsplit<CR>
" Focus on splits
exmap ftop obcommand editor:focus-top
nmap <C-k> :ftop<CR>
exmap fbottom obcommand editor:focus-bottom
nmap <C-j> :fbottom<CR>
exmap fleft obcommand editor:focus-left
nmap <C-h> :fleft<CR>
exmap fright obcommand editor:focus-right
nmap <C-l> :fright<CR>


" Open cmd palette
exmap cmd obcommand command-palette:open
nmap <Space>sc :cmd<CR>
exmap openContextMenu obcommand editor:context-menu
nmap <Space>1 :openContextMenu<CR>
vmap <Space>1 :openContextMenu<CR>
