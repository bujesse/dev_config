" Vundle
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'easymotion/vim-easymotion'
call vundle#end()
filetype plugin indent on
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append '!' to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append '!' to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append '!' to auto-approve removal

" vim-airline
let g:airline_theme='wombat'

" Basic configs
let mapleader=","
set backspace=indent,eol,start
syntax on
set scrolloff=2

" Relative numbering and toggle
set number relativenumber
map <leader>r :set rnu!<CR>

" Move up/down editor lines
" nnoremap j gj
" nnoremap k gk

" Center screen after High/Low commands
nnoremap L Lzz
nnoremap H Hzz

" Allow HIdden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
" nnoremap / /\v
" vnoremap / /\v
set hlsearch
hi Search ctermbg=DarkBlue
hi Search ctermfg=Black
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader>/ :noh<enter>

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

" Tabbing
set tabstop=4 shiftwidth=4 expandtab

" Remap ESC (insert and visual modes)
imap jk <Esc>
imap kj <Esc>
vmap jk <Esc>
vmap kj <Esc>

" Timeout for escape characters (important for remaping ESC)
set timeoutlen=125

" Replace word with last yank
map <leader>s diw"0P

" Replace word with last cut
map <leader>x "-Pldw

" Easymotion
map <Space> <Plug>(easymotion-bd-w)
"use for case insensitive:  let g:EasyMotion_smartcase = 1

" change dict.get to direct access
nmap <leader>g f.cf([<Esc>f)s]<Esc>
