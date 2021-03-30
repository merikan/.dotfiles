" start menu

" let g:startify_lists = [
"       \ { 'type': 'files',     'header': ['   MRU files']            },
"       \ { 'type': 'dir',       'header': ['   MRU directory'. getcwd()] },
"       \ { 'type': 'sessions',  'header': ['   Sessions']       },
"       \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
"       \ { 'type': 'commands',  'header': ['   Commands']       },
"       \ ]
" " path to sessions
" let g:startify_session_dir = '~/.config/nvim/session'
" " restart sessions
" let g:startify_session_autoload = 1
" " handle buffers
" let g:startify_session_delete_buffers = 1
" " cwd to cvs root
" let g:startify_change_to_vcs_root = 1
" " use unicode
" let g:startify_fortune_use_unicode = 1
" " update sessions
" let g:startify_session_persistence = 1


function! s:list_projects() abort
  return map(finddir('.git', $HOME . '/projects/**2', -1),
        \ {_, dir -> {'line': fnamemodify(dir, ':h:s?.*projects/??'), 'cmd': 'cd ' . fnamemodify(dir, ':h') . ' | Defx .'}})
endfunction


" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
       "\ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ {'header': ['   Projects'], 'type': function('s:list_projects'), 'indices': map(range(1, 100), { _ -> 'p' . string(v:val)})},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]

function! StartifyEntryFormat()
        return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction

let g:startify_bookmarks = [
            \ { 'd': '~/.dotfiles' },
            \ { 'g': '~/src/github.com' },
            \ { 'b': '~/src/bitbucket.com' },
            \ ]
