scriptencoding utf-8

filetype plugin indent on
set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all

" Wrap long lines with indentation
set breakindent
set breakindentopt=shift:2
" set clipboard+=unnamedplus
set completeopt=menu,menuone,noinsert,noselect

" more space in the neovim command line for displaying messages
set cmdheight=2

" Ask for confirmation when handling unsaved or read-only files
set confirm
set encoding=UTF-8

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99 " Start with no folds
set foldnestmax=10
set foldopen+=search,undo,quickfix,jump

" Always do global substitutes
set gdefault

" Switch to another buffer without writing or abandoning changes
set hidden

" Keep 200 changes of undo history
set history=200
set hlsearch
set ignorecase
set incsearch

" Smart casing when completing
set infercase

set iskeyword-=#

" We want a statusline
set laststatus=2
set lazyredraw
set mouse=a

" Hide the line terminating character
set nolist
set cursorline
" set cursorlineopt=number

" FUCK THIS SETTING. DUPES LINES ON FORMAT
" set nofixendofline

" No to double-spaces when joining lines
set nojoinspaces

" Makes it a little faster
set noshowcmd

" No jumping cursors when matching pairs
set noshowmatch
set noshowmode

" No backup files
set noswapfile

" Relative numbering (toggle with yor)
set number relativenumber
set pumheight=15

" Somehow this makes syntax highlighting in vim 100x faster
" set regexpengine=1

" Start scrolling when we're 8 lines away from margins
set scrolloff=8

" Using this to persist buffer locations https://github.com/akinsho/bufferline.nvim#configuration
set sessionoptions+=globals
" set sessionoptions=blank,curdir,tabpages,winpos,globals

" Use this to wrap long lines
set showbreak=↳
set sidescroll=1

" always render the sign column to prevent shifting
set signcolumn=yes
set smartcase
set smarttab
set splitright
set splitbelow
set colorcolumn=99999
set synmaxcol=200
set tabstop=4 shiftwidth=4 expandtab softtabstop=4

" Enable 24-bit color support for terminal Vim
set termguicolors

" No auto-newline
set textwidth=0 wrapmargin=0
set timeoutlen=500
set ttimeoutlen=10

" Set the persistent undo directory on temporary private fast storage.
set undofile
set updatetime=150

" Defines the trigger for 'wildmenu' in mappings
set wildcharm=<Tab>

" Ignore certain files and folders when globing
set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico
set wildignore+=*.pyc
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv

" ignore file and dir name cases in cmd-completion
set wildignorecase

" Nice command completions
set wildmenu

" Complete the next full match
set wildmode=full
