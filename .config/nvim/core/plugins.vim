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
    " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-bash' }
    " Plug 'junegunn/fzf.vim'
    " Plug 'pbogut/fzf-mru.vim'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " text editing/navigating
    Plug 'Konfekt/FastFold'                " Fixes issue where syntax folding makes vim really slow in larger files
    Plug 'Valloric/ListToggle'             " toggle quickfix and loclist
    Plug 'vim-scripts/ReplaceWithRegister' " replace with register: [count][\"x]gr{motion}
    Plug 'rhysd/clever-f.vim'
    Plug 'windwp/nvim-autopairs'           " Auto-input closing paired characters
    Plug 'easymotion/vim-easymotion'
    Plug 'tommcdo/vim-exchange'            " swap 2 text objects
    Plug 'michaeljsmith/vim-indent-object' " vii - visually select inside code block using current indentation; viI - include trailing line
    Plug 'tommcdo/vim-lion'                " Align text around a chosen character
    Plug 'terryma/vim-multiple-cursors'    " <C-n> and <C-p> to use multiple cursors
    Plug 'dbakker/vim-paragraph-motion'    " {} commands matche whitespace-only lines as well as empty lines
    Plug 'zhimsel/vim-stay'                " Keep editing session state while switching buffers
    Plug 'svermeulen/vim-yoink'            " keep yank history and cycle through

    " Intellisense
    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall'       " Install language servers with :LspInstall <language>
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    Plug 'rrethy/vim-illuminate'

    " Completion/Snippets
    Plug 'L3MON4D3/LuaSnip'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'f3fora/cmp-spell'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'saadparwaiz1/cmp_luasnip'

    " ui
    Plug 'morhetz/gruvbox'
    Plug 'glepnir/lspsaga.nvim'
    Plug 'akinsho/bufferline.nvim'
    Plug 'hoob3rt/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'thaerkh/vim-indentguides'
    Plug 'mhinz/vim-startify'
    Plug 'karb94/neoscroll.nvim'
    Plug 'onsails/lspkind-nvim'

    " Misc
    Plug 'nvim-lua/plenary.nvim'
    Plug 'romgrk/fzy-lua-native'

call plug#end()
