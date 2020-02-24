" TODO:
" - figure out what substitution/replace methods I want
" -- Global refactor/rename?
" - spell check?
" - python debugger
" - figure out optimal windowing/tabbing/buffers/splits
" - more formatting/organization/better grouping of this file
" - start using tmux
" - limit amount of autocomplete results
" - underline colors/style
" - master targets.vim
" - master fugitive (merging)
"===========================================================
" SETTINGS
"===========================================================

" Pre-Reqs:
" - vim version > 8
" - must have conceal feature (just install with brew to get all the features)
" - must have language servers installed
" - brew install fzf fd ripgrep

" Automatically install vim-plug and run PlugInstall if vim-plug is not found.
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
" tpope
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'               " crs and crc to change between cases; text replacement (e.g. facilities -> buildings)
Plug 'tpope/vim-unimpaired'            " navigation through [q]uickfix, [l]ocationlist, [b]ufferlist, linewise [p]aste
Plug 'tpope/vim-commentary'            " gc to toggle comments
Plug 'tpope/vim-fugitive'              " git wrapper

" files/git/searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-bash' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'mhinz/vim-grepper'

" text editing/navigating
Plug 'tmsvg/pear-tree'                 " Auto-input closing paired characters
Plug 'nelstrom/vim-visual-star-search'
Plug 'michaeljsmith/vim-indent-object' " vii - visually select inside code block using current indentation; viI - include trailing line
" Plug 'easymotion/vim-easymotion'     " I think I'll try using f and t movements instead of this
Plug 'rhysd/clever-f.vim'              " highlight/lock f and t movements and bind to f and t instead of ; and ,
Plug 'tommcdo/vim-lion'                " Align text around a chosen character
Plug 'drmingdrmer/vim-toggle-quickfix' " toggle quickfix and loclist
Plug 'wellle/targets.vim'
Plug 'Konfekt/FastFold'                " Fixes issue where syntax folding makes vim really slow in larger files
Plug 'mbbill/undotree'                 " undo history visualizer

" language/autcocomplete/linting/fixing
Plug 'sheerun/vim-polyglot'
Plug 'natebosch/vim-lsc'
Plug 'ajh17/VimCompletesMe'
Plug 'dense-analysis/ale'
Plug 'davidhalter/jedi-vim' " python renaming/usages
Plug 'tmhedberg/SimpylFold' " python folding

" ui
" Plug 'bluz71/vim-moonfly-colors'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

" colorscheme moonfly
colorscheme gruvbox

" === BASIC CONFIGS ===


" Enable syntax highlighting.
syntax on

let mapleader=","
set autoindent
set backspace=indent,eol,start
set completeopt=menu,menuone,noinsert,noselect
set foldmethod=syntax
set gdefault      " Always do global substitutes
set hidden        " Switch to another buffer without writing or abandoning changes
set history=200   " Keep 200 changes of undo history
set hlsearch
set ignorecase
set incsearch
set infercase     " Smart casing when completing
set nocompatible
set nofixendofline
set nojoinspaces  " No to double-spaces when joining lines
set noshowmatch   " No jumping jumping cursors when matching pairs
set noswapfile    " No backup files
set scrolloff=2
set showcmd
set showmatch
set showmode
set smartcase
set smarttab
set tabstop=4 shiftwidth=4 expandtab
set termguicolors " Enable 24-bit color support for terminal Vim
set timeoutlen=1000
set ttimeoutlen=10
set ttyfast
set updatetime=300

" Set the persistent undo directory on temporary private fast storage.
let s:undoDir="/tmp/.undodir_" . $USER
if !isdirectory(s:undoDir)
    call mkdir(s:undoDir, "", 0700)
endif
let &undodir=s:undoDir
set undofile          " Maintain undo history

map <leader>/ :noh<CR>
highlight Visual cterm=NONE

" Make timeout longer for leader
nmap <silent> <Leader> :<C-U>set timeoutlen=9999<CR><Leader>
autocmd CursorMoved * :set timeoutlen=1000

" display line movements unless preceded by a count. Also only add to jumplist if movement greater than 5
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

nnoremap L Lzz
nnoremap H Hzz

nnoremap n nzz
nnoremap N Nzz

imap jk <Esc>
imap kj <Esc>

" Y should behave like D and C
noremap Y y$

" U feels like a more natural companion to u
nnoremap U <C-r>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" nmap ]t :tabn<CR>
" nmap [t :tabp<CR>

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
map <leader>L :set list!<CR>

" Relative numbering and toggle
set number relativenumber
map <leader>r :set rnu!<CR>

" Auto remove trailing whitespace on save
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

" Close current buffer and move to the previous one
nmap <Leader>w :bp <BAR> bd #<CR>

" quick-toggle for zA fold
nnoremap <space> zAzz

" Apply the 'q' register macro to the visual selection
xnoremap Q :'<,'>:normal @q<CR>

" Source vimrc
nmap <silent> <leader>. :source $MYVIMRC<CR>


" === PLUGIN CONFIG ===


" ALE
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'python':     ['flake8'],
\  'css':        ['csslint'],
\  'scss':       ['sasslint'],
\  'json':       ['jsonlint'],
\  'yaml':       ['yamllint']
\}
let g:ale_fixers = {
\  'python':     ['autopep8'],
\  'javascript': ['eslint'],
\  'css':        ['prettier'],
\  'scss':       ['prettier'],
\  'json':       ['prettier'],
\  'yml':        ['prettier']
\}
let g:ale_linters_explicit = 1
let g:ale_open_list = 0
" highlight ALEErrorSign ctermbg=NONE ctermfg=red
" highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
nmap <Leader>af <Plug>(ale_fix)
nmap <Leader>al <Plug>(ale_toggle)
let g:ale_type_map = {'flake8': {'ES': 'WS'}}
let g:ale_python_flake8_options="--ignore=E501,W391"

" vim-grepper
let g:grepper = {}
let g:grepper.tools = ["rg"]
let g:grepper.searchreg = 0
let g:grepper.highlight = 0
runtime autoload/grepper.vim
" Customize regex
nnoremap <Leader>f :GrepperRg<Space>-i<Space>""<Left>
nnoremap gs :Grepper -cword -noprompt<CR>
xmap gs <Plug>(GrepperOperator)

" vim-lsc
" Use with jedi-vim for python since that has better rename and usage finding
" https://github.com/natebosch/vim-lsc/wiki/Language-Servers
let g:lsc_server_commands = {
 \  'python': {
 \    'command': 'pyls',
 \    'log_level': -1,
 \    'suppress_stderr': v:true,
 \  },
 \  'javascript': {
 \    'command': 'typescript-language-server --stdio',
 \    'log_level': -1,
 \    'suppress_stderr': v:true,
 \  }
 \}
let g:lsc_auto_map = {
 \  'GoToDefinition': 'gd',
 \  'FindReferences': 'gr',
 \  'NextReference': ']r',
 \  'PreviousReference': '[r',
 \  'Rename': 'gR',
 \  'ShowHover': 'gh',
 \  'FindCodeActions': 'ga',
 \  'Completion': 'omnifunc',
 \}
let g:lsc_enable_autocomplete  = v:true
let g:lsc_enable_diagnostics   = v:false
let g:lsc_reference_highlights = v:true
let g:lsc_trace_level          = 'off'
let g:pyindent_searchpair_timeout = 10  " This solves some kind of issue with pyindent making newlines lag

" jedi-vim
" Everything else is handled by vim-lsc
let g:jedi#usages_command           = "gu"
let g:jedi#rename_command           = "R"
let g:jedi#goto_command             = ""
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_stubs_command       = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command    = ""
let g:jedi#completions_command      = ""
let g:jedi#completions_enabled      = 0

" NERDTree
let NERDTreeHijackNetrw           = 0
let g:NERDTreeDirArrowExpandable  = "▷"
let g:NERDTreeDirArrowCollapsible = "◢"
let g:NERDTreeUpdateOnWrite       = 1
noremap <silent> <Leader>t :NERDTreeToggle<CR> <C-w>=
noremap <silent> <Leader>n :NERDTreeFind<CR> <C-w>=

" fzf
" Control-t (tab), use Control-x (horizontal split) or Control-v (verticle split)
nnoremap <silent> <Leader>o :Files<CR>
nnoremap <silent> <Leader>rg :Rg<Space>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>g :GFiles?<CR>

" vim-gitgutter
let g:gitgutter_grep                    = 'rg'
let g:gitgutter_map_keys                = 0
let g:gitgutter_sign_added              = '▎'
let g:gitgutter_sign_modified           = '▎'
let g:gitgutter_sign_modified_removed   = '▶'
let g:gitgutter_sign_removed            = '▶'
let g:gitgutter_sign_removed_first_line = '◥'
nmap [g <Plug>(GitGutterPrevHunk)
nmap ]g <Plug>(GitGutterNextHunk)
nmap <Leader>p <Plug>(GitGutterPreviewHunk)
nmap <Leader>+ <Plug>(GitGutterStageHunk)
nmap <Leader>- <Plug>(GitGutterUndoHunk)

" pear-tree
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_backspace   = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_openers     = 1

" vim-wordmotion
nmap cw ce

" Easymotion
" map <Space> <Plug>(easymotion-bd-f)
" let g:EasyMotion_smartcase = 1

" clever-f
let g:clever_f_across_no_line    = 1
let g:clever_f_fix_key_direction = 1
let g:clever_f_smart_case        = 1

" vim-lion
let g:lion_squeeze_spaces = 1

" vim-toggle-quickfix
nnoremap <silent> <Leader>c :call togglequickfix#ToggleQuickfix()<CR>
nnoremap <silent> <Leader>l :call togglequickfix#ToggleLocation()<CR>

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level           = 2
let g:indent_guides_guide_size            = 1

" vim-airline
let g:airline#extensions#tabline#enabled = 1

" FastFold
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['a','A','o','O','c','C','M','R']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" undotree
let g:undotree_HighlightChangedWithSign = 0
let g:undotree_WindowLayout             = 4
nnoremap <Leader>u :UndotreeToggle<CR>

" vim-fugitive
nnoremap <silent> <Leader>B :Gblame<CR>
nnoremap <silent> <Leader>C :Gclog %<CR>
nnoremap <silent> <Leader>D :Gdiffsplit<CR>
nnoremap <silent> <Leader>G :Gstatus<CR>


" === CUSTOM MACROS ===

" Replace word with last yank (repeatable)
nnoremap <Leader>v ciw<C-r>0<Esc>

" The following commands will work for word under cursor or visual selection
" [s]ubstitute in current file
nnoremap <Leader>s :let @s='\<'.expand('<cword>').'\>'<CR>:%s/<C-r>s//<Left>
xnoremap <Leader>s "sy:%s/<C-r>s//<Left>

" [S]ubstitute in entire project
nnoremap <Leader>S
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s// \| update
  \ <Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
xmap <Leader>S
  \ "sy \|
  \ :GrepperRg <C-r>s<CR>
  \ :cfdo %s/<C-r>s// \| update
  \ <Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" nearby find and [r]eplace
nnoremap <silent> <Leader>r :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> <Leader>r "sy:let @/=@s<CR>cgn
nnoremap <Enter> gnzz
xmap <Enter> .<Esc>gnzz
xnoremap ! <Esc>ngnzz
autocmd! BufReadPost quickfix nnoremap <buffer> <CR> <CR>
autocmd! CmdwinEnter *        nnoremap <buffer> <CR> <CR>

" === PERFORMANCE STUFF ===
augroup syntaxSyncMinLines
    autocmd!
    autocmd Syntax * syntax sync minlines=2000
augroup END

