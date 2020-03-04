" Automatically install vim-plug and run PlugInstall if vim-plug is not found.
if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Section: PLUGINS
    call plug#begin('~/.vim/bundle')
    " tpope
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-abolish'                             " crs and crc to change between cases; text replacement (e.g. facilities -> buildings)
    Plug 'tpope/vim-unimpaired'                        " navigation through [q]uickfix, [l]ocationlist, [b]ufferlist, linewise [p]aste
    Plug 'tpope/vim-commentary'                        " gc to toggle comments
    Plug 'tpope/vim-fugitive'                            " git wrapper
    " Plug 'tpope/vim-sleuth'                            " Tabbing

    " files/git/searching
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-bash' }
    Plug 'junegunn/fzf.vim'
    Plug 'pbogut/fzf-mru.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
    Plug 'mhinz/vim-grepper', { 'on': ['Grepper', 'GrepperRg', '<plug>(GrepperOperator)'] }  " enables lazy-loading
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'haya14busa/incsearch.vim'

    " text editing/navigating
    Plug 'tmsvg/pear-tree'                      " Auto-input closing paired characters
    Plug 'michaeljsmith/vim-indent-object'      " vii - visually select inside code block using current indentation; viI - include trailing line
    Plug 'easymotion/vim-easymotion'
    Plug 'tommcdo/vim-lion'                     " Align text around a chosen character
    Plug 'Valloric/ListToggle'                  " toggle quickfix and loclist
    Plug 'wellle/targets.vim'
    Plug 'Konfekt/FastFold'                     " Fixes issue where syntax folding makes vim really slow in larger files
    Plug 'mbbill/undotree'                      " undo history visualizer
    Plug 'zhimsel/vim-stay'                     " Keep editing session state while switching buffers
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    " language/autocomplete/linting/fixing
    Plug 'sheerun/vim-polyglot'
    Plug 'natebosch/vim-lsc'
    Plug 'ajh17/VimCompletesMe'
    Plug 'dense-analysis/ale'
    Plug 'davidhalter/jedi-vim'                 " python renaming/usages
    Plug 'alvan/vim-closetag'                   " auto-close html tags

    " Running tests/code/misc
    Plug 'janko/vim-test'
    Plug 'mtth/scratch.vim'

    " ui
    Plug 'morhetz/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'pangloss/vim-javascript'
    Plug 'Yggdroot/indentLine'
    Plug 'ryanoasis/vim-devicons'
    call plug#end()


" Section: UI CONFIGS
    colorscheme gruvbox
    set background=dark
    let g:gruvbox_contrast_dark='hard'
    syntax on


" Section: SET CONFIGS
    let mapleader=","
    set autoindent
    set autoread
    set backspace=indent,eol,start
    set breakindent                             " Wrap long lines *with* indentation
    set breakindentopt=shift:2
    set belloff=all
    set completeopt=menu,menuone,noinsert,noselect
    set encoding=UTF-8
    set foldlevelstart=20
    set foldmethod=indent
    set foldnestmax=3
    set foldopen+=search,undo,quickfix,jump
    set gdefault                                " Always do global substitutes
    set hidden                                  " Switch to another buffer without writing or abandoning changes
    set history=200                             " Keep 200 changes of undo history
    set hlsearch
    set ignorecase
    set incsearch
    set infercase                               " Smart casing when completing
    set laststatus=2                            " We want a statusline
    set lazyredraw
    " set mouse=a                                 " Mouse support in the terminal
    set nocompatible
    set nocursorline
    set nofixendofline
    set nojoinspaces                            " No to double-spaces when joining lines
    set noshowcmd                               " Makes it a little faster
    set noshowmatch                             " No jumping cursors when matching pairs
    set noswapfile                              " No backup files
    set pumheight=15
    set regexpengine=1                          " Somehow this makes syntax highlighting in vim 100x faster
    set sidescroll=1
    set scrolloff=8                             " Start scrolling when we're 8 lines away from margins
    set showbreak=↳                             " Use this to wrap long lines
    set noshowmode
    set signcolumn=yes                          " always render the sign column to prevent shifting
    set smartcase
    set smarttab
    " set spell spelllang=en_us
    " set spellfile=$HOME/.vim/spell/en.utf-8.add " zg to add to spellfile
    set splitright
    set synmaxcol=200
    set tabstop=4 shiftwidth=4 expandtab softtabstop=4
    set textwidth=0 wrapmargin=0                " No auto-newline
    set termguicolors                           " Enable 24-bit color support for terminal Vim
    set timeoutlen=1000
    set ttimeoutlen=10
    set ttyfast
    set updatetime=150
    set wildcharm=<Tab>                         " Defines the trigger for 'wildmenu' in mappings
    set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*,__pycache__
    set wildmenu                                " Nice command completions
    set wildmode=full                           " Complete the next full match


" Section: PLUGIN CONFIG
    " ALE
    let g:ale_linters = {
        \ 'javascript': ['eslint'],
        \ 'python':     ['flake8'],
        \ 'css':        ['csslint'],
        \ 'scss':       ['sasslint'],
        \ 'json':       ['jsonlint'],
        \ 'yaml':       ['yamllint']
        \}
    let g:ale_fixers = {
        \ 'python':     ['yapf'],
        \ 'javascript': ['eslint'],
        \ 'css':        ['prettier'],
        \ 'scss':       ['prettier'],
        \ 'json':       ['prettier'],
        \ 'yml':        ['prettier']
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
    nnoremap <Leader>F :GrepperRg<Space>-i<Space>""<Left>
    nnoremap gs :Grepper -cword -noprompt<CR>
    xmap gs <Plug>(GrepperOperator)

    " vim-lsc
    " Use with jedi-vim for python since that has better rename and usage finding
    " https://github.com/natebosch/vim-lsc/wiki/Language-Servers
    let g:lsc_server_commands = {
        \    'python': {
        \        'command': 'pyls',
        \        'log_level': -1,
        \        'suppress_stderr': v:true,
        \    },
        \    'javascript': {
        \        'command': 'typescript-language-server --stdio',
        \        'log_level': -1,
        \        'suppress_stderr': v:true,
        \    }
        \}
    let g:lsc_auto_map = {
        \    'GoToDefinition': 'gd',
        \    'FindReferences': 'gr',
        \    'NextReference': ']r',
        \    'PreviousReference': '[r',
        \    'Rename': 'gR',
        \    'ShowHover': 'K',
        \    'FindCodeActions': 'ga',
        \    'Completion': 'omnifunc',
        \}
    let g:lsc_enable_autocomplete  = v:true
    let g:lsc_enable_diagnostics   = v:false
    let g:lsc_reference_highlights = v:true
    let g:lsc_trace_level          = 'off'

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
    let NERDTreeRespectWildIgnore     = 1
    noremap <silent> <Leader>nt :NERDTreeToggle<CR> <C-w>=
    noremap <silent> <Leader>nf :NERDTreeFind<CR> <C-w>=
    " make sure vim does not open files and other buffers on NerdTree window
    autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
    " close vim if NerdTree is the last window
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " fzf
        " Control-t (tab), use Control-x (horizontal split) or Control-v (verticle split)
        " tab to select multiple, option-a to select all
        let g:fzf_history_dir = "~/.fzf_history"
        let g:fzf_commits_log_options = '--graph --color=always
            \ --format="%C(yellow)%h%C(red)%d%C(reset)
            \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
        nnoremap <silent> <Leader>o :Files<CR>
        nnoremap <silent> <Leader>f :RG<CR>
        nnoremap <silent> <Leader>b :Buffers<CR>
        nnoremap <silent> <Leader>g :GFiles?<CR>

        " allows searching of snippet definitions
        command! -bar -bang Snippets call fzf#vim#snippets({'options': '-n ..'}, <bang>0)

        " Insert mode completion
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
    nmap <Leader>P <Plug>(GitGutterPreviewHunk)
    nmap <Leader>+ <Plug>(GitGutterStageHunk)
    nmap <Leader>- <Plug>(GitGutterUndoHunk)

    " pear-tree
    let g:pear_tree_repeatable_expand = 0
    let g:pear_tree_smart_backspace   = 1
    let g:pear_tree_smart_closers     = 1
    let g:pear_tree_smart_openers     = 1
    let g:pear_tree_timeout           = 60

    " Easymotion
    let g:EasyMotion_smartcase = 1
    nmap s <Plug>(easymotion-s2)

    " vim-lion
    let g:lion_squeeze_spaces = 1

    " vim-airline
    let g:airline#extensions#tabline#enabled = 1 " Show buffers
    let g:airline_detect_spelllang           = 0
    let g:airline_detect_spell               = 0

    " FastFold
    let g:fastfold_savehook               = 1
    let g:fastfold_fold_command_suffixes  = ['a','A','o','O','c','C','M','R']
    let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

    " undotree
    let g:undotree_HighlightChangedWithSign = 0
    let g:undotree_WindowLayout             = 4
    nnoremap <Leader>u :UndotreeToggle<CR>

    " vim-fugitive
    " :G is shorthand for :Gstatus
    nnoremap <silent> <Leader>B :Gblame<CR>
    nnoremap <silent> <Leader>L :Gclog %<CR>
    nnoremap <silent> <Leader>D :Gdiffsplit<CR>
    nnoremap <silent> <Leader>M :Git mergetool<CR>

    " vim-stay
    set viewoptions=cursor,slash,unix

    " ultisnips
    let g:UltiSnipsSnippetsDir         = '~/.vim/bundle/vim-snippets/UltiSnips'
    let g:UltiSnipsExpandTrigger       = "<C-j>"
    let g:UltiSnipsJumpForwardTrigger  = "<C-j>"
    let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
    let g:UltiSnipsListSnippets        = "<C-l>"
    nnoremap <leader>eu :UltiSnipsEdit<cr>

    " indentLine
    let g:indentLine_char_list  = ['|', '¦', '┆', '┊']
    let g:indentLine_faster     = 1
    let g:indentLine_setConceal = 0

    " vim-python (in polyglot)
    let g:python_highlight_all = 1
    let g:python_highlight_indent_errors = 0
    let g:python_highlight_space_errors  = 0

    " vim-test
    nnoremap <silent> <Leader>tn :TestNearest<CR>
    nnoremap <silent> <Leader>tf :TestFile<CR>
    nnoremap <silent> <Leader>ts :TestSuite<CR>
    nnoremap <silent> <Leader>tl :TestLast<CR>
    nnoremap <silent> <Leader>tv :TestVisit<CR>
    let test#strategy = "vimterminal"
    let test#project_root = "~/dev/the-doc-man/api"

    " vim-closetag
    " Double-tap > when closing a tag to auto newline
    let g:closetag_filenames = '*.html,*.js'

    " scratch.vim
    let g:scratch_no_mappings = 1
    let g:scratch_insert_autohide = 0
    nmap <leader>es <plug>(scratch-insert-reuse)
    xmap <leader>es <plug>(scratch-selection-reuse)

    " incsearch.vim
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
    " noh when doing other movement
    let g:incsearch#auto_nohlsearch = 1
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)
    map *  <Plug>(incsearch-nohl-*)
    map #  <Plug>(incsearch-nohl-#)
    map g* <Plug>(incsearch-nohl-g*)
    map g# <Plug>(incsearch-nohl-g#)


" Section: PERSONAL CONFIGS
    " Set the persistent undo directory on temporary private fast storage.
    let s:undoDir="/tmp/.undodir_" . $USER
    if !isdirectory(s:undoDir)
            call mkdir(s:undoDir, "", 0700)
    endif
    let &undodir=s:undoDir
    set undofile                    " Maintain undo history

    map <leader>/ :noh<CR>

    " Don't make the visual colors reversed
    highlight Visual cterm=NONE

    " Make timeout longer for leader
    " nmap <silent> <Leader> :<C-U>set timeoutlen=9999<CR><Leader>
    " autocmd CursorMoved * :set timeoutlen=1000

    " display line movements unless preceded by a count. Also only add to jumplist if movement greater than 5
    nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
    nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

    nnoremap L Lzz
    nnoremap H Hzz

    imap jk <Esc>
    imap Jk <Esc>
    imap jK <Esc>
    imap JK <Esc>

    imap kj <Esc>
    imap Kj <Esc>
    imap kJ <Esc>
    imap KJ <Esc>

    command WQ wq
    command Wq wq
    command W w
    command Q q

    " Y should behave like D and C
    noremap Y y$

    " U feels like a more natural companion to u
    nnoremap U <C-r>

    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    nmap ]t :tabn<CR>
    nmap [t :tabp<CR>

    " Visualize tabs and newlines
    " set listchars=tab:▸\ ,eol:¬
    " map <leader>L :set list!<CR>

    " Relative numbering (toggle with yor)
    set number relativenumber

    " Auto remove trailing whitespace on save
    fun! TrimWhitespace()
            let l:save = winsaveview()
            keeppatterns %s/\s\+$//e
            call winrestview(l:save)
    endfun
    autocmd BufWritePre * :call TrimWhitespace()

    " Buffer stuff
        " Close current buffer and move to the previous one
        nmap <Leader>w :bp <BAR> bd! #<CR>
        let g:airline#extensions#tabline#buffer_nr_show = 1

    " toggle a selected fold opened/closed.
    nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
    vnoremap <Space> zf

    " Apply the 'q' register macro to the visual selection
    xnoremap Q :'<,'>:normal @q<CR>

    " Source vimrc
    nmap <silent> <leader>. :source $MYVIMRC<CR>

    " auto-indent pasted text
    nnoremap p p=`]<C-o>
    nnoremap P P=`]<C-o>

    " paste from yank
    nnoremap <C-p> "0p

    " quick resize window size
    nnoremap <silent> <Up>    :resize +5<CR>
    nnoremap <silent> <Down>  :resize -5<CR>
    nnoremap <silent> <Left>  :vertical resize -5<CR>
    nnoremap <silent> <Right> :vertical resize +5<CR>

    " terminal mappings (testing for example)
        " hi Terminal ctermbg=lightgrey ctermfg=blue guibg=lightgrey guifg=blue
        " put yank in terminal
        tmap <C-p> <C-w>"0
        " normal mode
        tmap <C-n> <C-w>N
        tmap <C-k> <C-w><C-k>
        tmap <C-j> <C-w><C-j>
        tmap <C-l> <C-w><C-l>
        tmap <C-h> <C-w><C-h>
        tnoremap <Esc> <C-\><C-n>


" Section: CUSTOM MACROS
    " Replace word with last yank (repeatable)
    nnoremap <Leader>v ciw<C-r>0<Esc>

    " nearby find and [r]eplace
    nnoremap <silent> <Leader>r :let @/='\<'.expand('<cword>').'\>'<CR>cgn
    xnoremap <silent> <Leader>r "sy:let @/=@s<CR>cgn

    " Use "/c" at the end to choose
    " [s]ubstitute in current file
    nnoremap <Leader>s :let @s='\<'.expand('<cword>').'\>'<CR>:%s/<C-r>s/
    xnoremap <Leader>s "sy:%s/<C-r>s/

    " [S]ubstitute in entire project
    nnoremap <Leader>S
        \ :let @s='\<'.expand('<cword>').'\>'<CR>
        \ :Grepper -cword -noprompt<CR>
        \ :cfdo %S/<C-r>s/ \| update
        \ <Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
    xmap <Leader>S
        \ "sy \|
        \ :GrepperRg <C-r>s<CR>
        \ :cfdo %S/<C-r>s/ \| update
        \ <Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

    " Run python on current buffer
    nnoremap <buffer> <F1> :exec '!python' shellescape(@%, 1)<cr>


" Section: PERFORMANCE STUFF
    " IMPORTANT: in ~/.vim/bundle/polyglot/indent/python.vim this makes newlines a lot faster
        " Also add these:
            " let s:paren_pairs = {'()': 25, '[]': 25, '{}': 25}
            " let skip_special_chars = ''
    let g:python_pep8_indent_searchpair_timeout = 10

    augroup syntaxSyncMinLines
        autocmd!
        autocmd Syntax * syntax sync minlines=2000
    augroup END


    augroup autoRead
        autocmd!
        autocmd CursorHold * silent! checktime
    augroup END

" Section: TIPS
    " - Toggle line wrapping: yow
    " - surround plugin does tags: dst, cst<div>, and lines: yss<div>
    " - insert mode <C-w> to delete word
    " - ':' mode <C-f> to search through ':' history
    " - gi to insert mode at last insert mode, and gv to visual mode last visual mode
    " - instead of visually selecting a long delete/yank, just ma and go to where you want to end, then do y'a or d'a
    " - Git stuff:
        " g? Show :Gstatus help.
        " - Stage or unstage a file in :Gstatus.
        " = Toggle inline diff in :Gstatus.
        " dv Display a vdiff on the current file in :Gstatus.
        " cc Commit the current staged files in :Gstatus.

" Section: TODO
    " - Global refactor/rename?
    " - python debugger
    " - figure out optimal windowing/tabbing/buffers/splits
    " - start using tmux
    " - underline colors/style
    " - master fugitive merging
    " - work on zshrc organization
    " - python yapf config (ale-fixing)
    " - script to open visual selection in new buffer and add boilerplate python code
    " - figure out how to hit <CR> to select an autocomplete
    " - Start using ctags (with fzf)
    " - figure out surround bug with <space>
    " - figure out render lag
    " - macro to add debuggers (js and python)
    " - try using emmet-vim
    " - vim mode in terminal
    " - terminal colors for py debugging
    " - analyze startup cost and optimize lazy loading
    " - try vim-peekaboo
    " - try tabular and vim-easy-align for align (instead of vim-lion)
    " - make Airline less noisy
    " - make fold text better

" Section PRE REQUISITES
    " - vim version > 8
    " - must have conceal feature (just install with brew to get all the features)
    " - must have language servers installed
    " - brew install fzf fd ripgrep
    " - pip install from .vim.requirements.txt
    " - install a nerd-font from https://github.com/ryanoasis/nerd-fonts

