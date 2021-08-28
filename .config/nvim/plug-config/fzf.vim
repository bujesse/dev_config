" Control-t (tab), use Control-x (horizontal split) or Control-v (verticle split)
" tab to select multiple, option-a to select all
let g:fzf_history_dir = "~/.fzf_history"
let g:fzf_commits_log_options = '--graph --color=always
            \ --format="%C(yellow)%h%C(red)%d%C(reset)
            \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
nnoremap <silent> <Leader>o :Files<CR>
nnoremap <silent> <Leader>f :RG<CR>
nnoremap <silent> <Leader>g :GFiles?<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>hc :History:<CR>
nnoremap <silent> <Leader>hs :History/<CR>

" allows searching of snippet definitions
command! -bar -bang Snippets call fzf#vim#snippets({'options': '-n ..'}, <bang>0)

" Insert mode completion
inoremap <expr> <c-x><c-w> fzf#vim#complete#word({'left': '15%'})
inoremap <c-x><c-w> fzf#vim#complete#word({'left': '15%'})
imap <c-x><c-f> <plug>(fzf-complete-path)

" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
            \ 'prefix': '^.*$',
            \ 'source': 'rg -n ^ --color always',
            \ 'options': '--ansi --delimiter : --nth 3..',
            \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

" This function makes ripgrepping behave like how finding in jetbrains works
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" fzf-mru
nnoremap <silent> <leader>m :FZFMru -m<cr>
" Only list files within current directory.
let g:fzf_mru_relative = 1
" keep list sorted by recency
let g:fzf_mru_no_sort = 1
