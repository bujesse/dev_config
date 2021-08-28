let mapleader=","
map <leader>/ :noh<CR>

" Don't make the visual colors reversed
highlight Visual cterm=NONE
" Search highlight color
highlight Search guifg=#83a598

command WQ wq
command Wq wq
command W w
command Q q

" Y should behave like D and C
noremap Y y$

" Move the cursor based on physical lines, not the actual lines.
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap ^ g^
nnoremap 0 g0

" paste from yank
nnoremap <C-p> "0P

" U feels like a more natural companion to u
nnoremap U <C-r>

" Center after search
nnoremap n nzzzv
nnoremap N Nzzzv

noremap <space> :
noremap <space><space> :w<CR>

nmap ]t :tabn<CR>
nmap [t :tabp<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Source init.vim
nmap <silent> <leader>. :source ~/.config/nvim/init.vim<CR>

" format entire file
nnoremap + gg=G<C-o><C-o>zz

" Continuous visual shifting (does not exit Visual mode)
xnoremap < <gv
xnoremap > >gv

" Section: CUSTOM MACROS
" Replace word with last yank (repeatable)
nnoremap <Leader>v ciw<C-r>0<Esc>
xnoremap <Leader>v c<C-r>0<Esc>

" Replace word with last cut (repeatable)
nnoremap <Leader>c "_ciw<C-r>-<Esc>
xnoremap <Leader>c "_c<C-r>-<Esc>

" Profiler
nnoremap <F2> :profile start profile.log<bar>profile file *<bar>profile func *<cr>

" insert current timestamp
nnoremap gts :pu=strftime('%c')<CR>

" Apply the 'q' register macro to the visual selection
xnoremap Q :'<,'>:norm @q<CR>
