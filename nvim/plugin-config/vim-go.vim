
" Syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
" Enable auto formatting on saving
let g:go_fmt_autosave = 1
" Run `goimports` on your current file on every save
let g:go_fmt_command = "goimports"
" Status line types/signatures
let g:go_auto_type_info = 1

" Go Add Tags
let g:go_addtags_transform = 'camelcase'
noremap gat :GoAddTags<cr>

" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" - Go bindinds to localleader
" augroup myGolang
"     au!
"     autocmd FileType go
"         \  nmap <buffer> <LocalLeader>r   <Plug>(go-run)
"         \| nmap <buffer> <LocalLeader>b   <Plug>(go-build)
"         \| nmap <buffer> <LocalLeader>t   <Plug>(go-test)
"         \| nmap <buffer> <LocalLeader>c   <Plug>(go-coverage)
"         \| nmap <buffer> <LocalLeader>gd  <Plug>(go-doc)
"         \| nmap <buffer> <LocalLeader>gv  <Plug>(go-doc-vertical)
"         \| nmap <buffer> <LocalLeader>s   <Plug>(go-implements)
"         \| nmap <buffer> <LocalLeader>i   <Plug>(go-info)
" augroup END