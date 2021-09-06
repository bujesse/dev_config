let g:startify_bookmarks = [
            \ {'n': '~/.config/nvim/init.vim'},
            \ {'i': '~/.ideavimrc'},
            \ {'z': '~/.zshrc'},
            \ {'a': '/mnt/c/Users/Jesse/AppData/Roaming/alacritty/alacritty.yml'},
            \ ]

let g:startify_change_to_vcs_root = 1
let g:startify_session_dir = '~/.config/nvim/session'

" Sometimes the wilder buffers don't close before a ZZ
let g:startify_session_before_save = [ 'silent! bw! [Wilder Float 0]', 'silent! bw! [Wilder Float 1]' ]

" This prevents NvimTree from freaking out when loading a session
let g:startify_session_savecmds = [ 'silent! bw! NvimTree' ]

let g:ascii = [
\ '________   _______   ________  ___      ___ ___  _____ ______',
\ '|\   ___  \|\  ___ \ |\   __  \|\  \    /  /|\  \|\   _ \  _   \',
\ '\ \  \\ \  \ \   __/|\ \  \|\  \ \  \  /  / | \  \ \  \\\__\ \  \',
\ ' \ \  \\ \  \ \  \_|/_\ \  \\\  \ \  \/  / / \ \  \ \  \\|__| \  \',
\ '  \ \  \\ \  \ \  \_|\ \ \  \\\  \ \    / /   \ \  \ \  \    \ \  \',
\ '   \ \__\\ \__\ \_______\ \_______\ \__/ /     \ \__\ \__\    \ \__\',
\ '    \|__| \|__|\|_______|\|_______|\|__|/       \|__|\|__|     \|__|',
\ '',
\ '',
\ ]

let g:startify_custom_header = 'startify#pad(g:ascii + startify#fortune#boxed())'

let g:startify_lists = [
        \ { 'type': 'sessions',  'header': [' Sessions'] },
        \ { 'type': 'files',     'header': [' MRU'] },
        \ { 'type': 'dir',       'header': [' MRU '. getcwd()] },
        \ { 'type': 'bookmarks', 'header': [' Bookmarks'] },
        \ ]

let g:startify_session_persistence = 1

" Save and load sessions
noremap <F5> :SSave!<CR>
noremap <F8> :SLoad<CR>

nnoremap <Leader>s :Startify<CR>
