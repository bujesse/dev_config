let NERDTreeHijackNetrw           = 0
let g:NERDTreeDirArrowExpandable  = "▷"
let g:NERDTreeDirArrowCollapsible = "◢"
let g:NERDTreeUpdateOnWrite       = 1
let NERDTreeRespectWildIgnore     = 1
noremap <silent> <Leader>N :NERDTreeToggle<CR>
noremap <silent> <Leader>n :NERDTreeFind<CR>
" make sure vim does not open files and other buffers on NerdTree window
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
" close vim if NerdTree is the last window
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
