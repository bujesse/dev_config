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

nnoremap j <cmd>call bu#jump_direction('j')<CR>
nnoremap k <cmd>call bu#jump_direction('k')<CR>

nnoremap <silent> gj <cmd>call bu#float_up('j')<CR>
nnoremap <silent> gk <cmd>call bu#float_up('k')<CR>

" Run the last command
nnoremap <leader>; :<up>

" Sizing window
nnoremap <Left> <C-W>5<
nnoremap <Right> <C-W>5>
nnoremap <Up> <C-W>5+
nnoremap <Down> <C-W>5-

nnoremap ^ g^
nnoremap 0 g0

" paste from yank
" nnoremap <C-p> "0P

" U feels like a more natural companion to u
nnoremap U <C-r>
nnoremap <C-z> u

map <C-y> "*y

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
nnoremap + gg=G<C-o>zz

" Continuous visual shifting (does not exit Visual mode)
xnoremap < <gv
xnoremap > >gv

" Section: CUSTOM MACROS
" Replace word with last yank (repeatable)
nnoremap <Leader>v ciw<C-r>0<Esc>
xnoremap <Leader>v c<C-r>0<Esc>

nmap <Leader>V yy[y<leader>v]y]yPj

" Replace word with last cut (repeatable)
nnoremap <Leader>c "_ciw<C-r>-<Esc>
xnoremap <Leader>c "_c<C-r>-<Esc>

" Profiler
" nnoremap <F2> :profile start profile.log<bar>profile file *<bar>profile func *<cr>

" insert current timestamp
nnoremap gts :pu=strftime('%c')<CR>

" Apply the 'q' register macro to the visual selection
xnoremap Q :'<,'>:norm @q<CR>
