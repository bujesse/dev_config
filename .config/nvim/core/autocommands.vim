augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup END

" Auto remove trailing whitespace on save
function! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

" Buffer stuff
    " Skip quickfix buffer when cycling, and don't allow buffer cycling in the quickfix
    function! BSkipQuickFix(command)
        if &buftype ==# 'quickfix'
            return
        endif
        let start_buffer = bufnr('%')
        execute a:command
        while &buftype ==# 'quickfix' && bufnr('%') != start_buffer
            execute a:command
        endwhile
    endfunction
    nnoremap ]b :call BSkipQuickFix(":bn")<CR>
    nnoremap [b :call BSkipQuickFix(":bp")<CR>

    " Close current buffer and move to the previous one
    function! BCloseSkipQuickFix()
        let start_buffer = bufnr('%')
        execute ":bp"
        while &buftype ==# 'quickfix' && bufnr('%') != start_buffer
            execute ":bp"
        endwhile
        execute "bd! " . start_buffer
    endfunction
    nmap <Leader>x :call BCloseSkipQuickFix()<CR>

    " quit if the last buffer is a quickfix
    autocmd BufEnter * if (winnr("$") == 1 && &buftype ==# 'quickfix') | q | endif


" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
