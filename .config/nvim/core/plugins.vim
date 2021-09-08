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
    Plug 'haya14busa/vim-asterisk'
    Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-frecency.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    " Plug 'ahmedkhalf/project.nvim'

    " text editing/navigating
    Plug 'Valloric/ListToggle'             " toggle quickfix and loclist
    Plug 'vim-scripts/ReplaceWithRegister' " replace with register: [count][\"x]gr{motion}
    Plug 'windwp/nvim-autopairs'           " Auto-input closing paired characters
    " Plug 'easymotion/vim-easymotion'
    " Plug 'ggandor/lightspeed.nvim'
    Plug 'rhysd/clever-f.vim'
    Plug 'phaazon/hop.nvim'
    Plug 'tommcdo/vim-exchange'            " swap 2 text objects
    Plug 'michaeljsmith/vim-indent-object' " vii - visually select inside code block using current indentation; viI - include trailing line
    " Plug 'tommcdo/vim-lion'              " Align text around a chosen character
    Plug 'junegunn/vim-easy-align'         " Align text around a chosen character
    Plug 'mg979/vim-visual-multi'          " Multiple cursors
    Plug 'dbakker/vim-paragraph-motion'    " {} commands match whitespace-only lines as well as empty lines
    Plug 'zhimsel/vim-stay'                " Keep editing session state while switching buffers
    Plug 'svermeulen/vim-yoink'            " keep yank history and cycle through
    " Plug 'AckslD/nvim-revJ.lua'          " expand one-liner multi-line
    Plug 'AndrewRadev/splitjoin.vim'       " expand one-liner multi-line
    Plug 'kana/vim-textobj-user'           " Create your own text objects
    Plug 'sgur/vim-textobj-parameter'      " Required for nvim-revJ.lua

    " Intellisense
    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall'       " Install language servers with :LspInstall <language>
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    Plug 'rrethy/vim-illuminate'
    Plug 'jose-elias-alvarez/null-ls.nvim'

    " Completion/Snippets
    Plug 'L3MON4D3/LuaSnip'
    Plug 'rafamadriz/friendly-snippets'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'f3fora/cmp-spell'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'saadparwaiz1/cmp_luasnip'

    " UI
    " Plug 'bluz71/vim-moonfly-colors'
    " Plug 'folke/tokyonight.nvim'
    " Plug 'sainnhe/sonokai'
    Plug 'sainnhe/gruvbox-material'
    " Plug 'navarasu/onedark.nvim'
    Plug 'glepnir/lspsaga.nvim'
    " Plug 'akinsho/bufferline.nvim'
    Plug 'hoob3rt/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'karb94/neoscroll.nvim'
    Plug 'onsails/lspkind-nvim'
    Plug 'romgrk/barbar.nvim'
    Plug 'mhinz/vim-startify'
    " Plug 'glepnir/dashboard-nvim'

    " Debugging
    Plug 'mfussenegger/nvim-dap'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'mfussenegger/nvim-dap-python'

    " Performance
    Plug 'antoinemadec/FixCursorHold.nvim' " Needed while issue https://github.com/neovim/neovim/issues/12587 is still open

    " Misc
    Plug 'nvim-lua/plenary.nvim'
    Plug 'romgrk/fzy-lua-native'
    Plug 'folke/which-key.nvim'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
    Plug 'tami5/sqlite.lua'

call plug#end()
