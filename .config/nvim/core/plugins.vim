" Automatically install vim-plug and run PlugInstall if vim-plug is not found.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync
endif

" VIMPLUG DECLARATIONS
call plug#begin('~/.config/nvim/plugged')
    " tpope
    Plug 'tpope/vim-abolish'    " crs and crc to change between cases; text replacement (e.g. facilities -> buildings)
    Plug 'tpope/vim-commentary' " gc to toggle comments
    Plug 'tpope/vim-fugitive'   " git wrapper
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired' " navigation through [q]uickfix, [l]ocationlist, [b]ufferlist, linewise [p]aste

    " files/git/searching
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-bash' }
    Plug 'junegunn/fzf.vim'
    Plug 'pbogut/fzf-mru.vim'
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
    Plug 'airblade/vim-gitgutter'
    Plug 'nelstrom/vim-visual-star-search'

    " text editing/navigating
    Plug 'Konfekt/FastFold'                " Fixes issue where syntax folding makes vim really slow in larger files
    Plug 'Valloric/ListToggle'             " toggle quickfix and loclist
    Plug 'vim-scripts/ReplaceWithRegister' " replace with register: [count][\"x]gr{motion}
    Plug 'rhysd/clever-f.vim'
    Plug 'tmsvg/pear-tree'                 " Auto-input closing paired characters
    Plug 'wellle/targets.vim'
    Plug 'easymotion/vim-easymotion'
    Plug 'tommcdo/vim-exchange'            " swap 2 text objects
    Plug 'michaeljsmith/vim-indent-object' " vii - visually select inside code block using current indentation; viI - include trailing line
    Plug 'tommcdo/vim-lion'                " Align text around a chosen character
    Plug 'terryma/vim-multiple-cursors'    " <C-n> and <C-p> to use multiple cursors
    Plug 'dbakker/vim-paragraph-motion'    " {} commands matche whitespace-only lines as well as empty lines
    Plug 'zhimsel/vim-stay'                " Keep editing session state while switching buffers

    " Intellisense
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-compe'

    " ui
    Plug 'morhetz/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'ryanoasis/vim-devicons'
    Plug 'thaerkh/vim-indentguides'
    Plug 'mhinz/vim-startify'

call plug#end()