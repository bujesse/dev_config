"smart indent when entering insert mode with i on empty lines
function! IndentWithI(cmd)
    if len(getline('.')) == 0
        return 'cc'
    else
        return a:cmd
    endif
endfunction

nnoremap <expr> i IndentWithI('i')
nnoremap <expr> a IndentWithI('a')
nnoremap <expr> A IndentWithI('A')
