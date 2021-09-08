" Auto remove trailing whitespace on save
function! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

" Buffer stuff
    " Close current buffer and move to the previous one
    function! BCloseSkipQuickFix()
        let start_buffer = bufnr('%')
        execute ":bp"
        while &buftype ==# 'quickfix' && bufnr('%') != start_buffer
            execute ":bp"
        endwhile
        execute "bd! " . start_buffer
    endfunction
    " nmap <Leader>x :call BCloseSkipQuickFix()<CR>

    " quit if the last buffer is a quickfix
    autocmd BufEnter * if (winnr("$") == 1 && &buftype ==# 'quickfix') | q | endif

