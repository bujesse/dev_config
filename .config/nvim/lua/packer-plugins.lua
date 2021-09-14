return {
  -- Packer can manage itself as an optional plugin
  { 'wbthomason/packer.nvim' },
  {
    'folke/which-key.nvim',
    config = function()
      require('plugins.which-key').config()
    end,
    event = 'BufWinEnter',
  },
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
  },
  { 'rrethy/vim-illuminate' },
  { 'tamago324/nlsp-settings.nvim' },
  { 'jose-elias-alvarez/null-ls.nvim' },
  { 'antoinemadec/FixCursorHold.nvim' }, -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  {
    'kabouzeid/nvim-lspinstall',
    event = 'VimEnter',
    config = function()
      require('plugins.lsp.nvim-lspconfig').config()
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('plugins.nvim-treesitter').config()
    end,
    run = ':TSUpdate',
    after = {
      'which-key.nvim',
    },
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter-textobjects',
  -- },

  { 'nvim-lua/plenary.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('plugins.telescope').config()
    end,
    after = {'which-key.nvim'},
    requires = {
      {
        'nvim-telescope/telescope-frecency.nvim',
        requires = { 'tami5/sqlite.lua' },
      },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      require('plugins.nvim-cmp').config()
    end,
    requires = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'ray-x/cmp-treesitter',
    },
  },
  {
    'rafamadriz/friendly-snippets',
  },

  {
    'windwp/nvim-autopairs',
    -- event = "InsertEnter",
    after = 'nvim-cmp',
    config = function()
      require('plugins.nvim-autopairs').config()
    end,
  },

  {
    'kyazdani42/nvim-tree.lua',
    -- event = "BufWinOpen",
    -- cmd = "NvimTreeToggle",
    config = function()
      require('plugins.nvim-tree').config()
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('plugins.gitsigns').config()
    end,
    event = 'BufRead',
  },

  -- Tpope
  -- crs and crc to change between cases; text replacement (e.g. facilities -> buildings)
  {
    'tpope/vim-abolish',
    config = function()
      require('plugins.abolish').config()
    end,
    after = {'which-key.nvim'},
  },
  -- gc to toggle comments
  { 'tpope/vim-commentary' },
  -- git wrapper
  {
    'tpope/vim-fugitive',
    config = function()
      require('plugins.vim-fugitive').config()
    end,
  },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },

  -- {
  --   'gelguy/wilder.nvim',
  --   config = require('plugins.wilder').config,
  --   run = ':UpdateRemotePlugins',
  -- },

  -- Text Editing
  {
    -- replace with register: [count][\"x]R{motion}
    'vim-scripts/ReplaceWithRegister',
    config = function()
      require('plugins.replace-with-register').config()
    end,
  },
  {
    'rhysd/clever-f.vim',
    config = function()
      require('plugins.clever-f').config()
    end,
  },
  {
    'phaazon/hop.nvim',
    config = function()
      require('plugins.hop').config()
    end,
  },
  {
    'haya14busa/vim-asterisk',
    config = function()
      require('plugins.vim-asterisk').config()
    end,
  },
  {
    -- swap 2 text objects
    'tommcdo/vim-exchange',
  },
  {
    -- Align text around a chosen character
    'junegunn/vim-easy-align',
    config = function()
      require('plugins.vim-easy-align').config()
    end,
  },
  {
    -- Multiple cursors
    'mg979/vim-visual-multi',
  },
  {
    -- keep yank history and cycle through
    'svermeulen/vim-yoink',
    config = function()
      require('plugins.vim-yoink').config()
    end,
  },
  {
    -- expand one-liner multi-line
    'AndrewRadev/splitjoin.vim',
    config = function()
      require('plugins.splitjoin').config()
    end,
  },

  -- Text Objexts
  { 'michaeljsmith/vim-indent-object' },
  { 'dbakker/vim-paragraph-motion' },

  -- Comments
  -- {
  --   'terrortylor/nvim-comment',
  --   event = 'BufRead',
  --   config = function()
  --     require('core.comment').setup()
  --   end,
  --   disable = not lvim.builtin.comment.active,
  -- },

  -- Icons
  { 'kyazdani42/nvim-web-devicons' },

  -- Status Line and Bufferline
  {
    -- "hoob3rt/lualine.nvim",
    'shadmansaleh/lualine.nvim',
    config = function()
      require('plugins.lualine').config()
    end,
    after = {'gruvbox-material'},
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('plugins.indent-blankline').config()
    end,
  },
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('plugins.neoscroll').config()
    end,
  },

  { 'onsails/lspkind-nvim' },

  {
    'mhinz/vim-startify',
    config = function()
      require('plugins.startify').config()
    end,
  },

  {
    'sainnhe/gruvbox-material',
    config = function()
      vim.cmd([[source ~/.config/nvim/core/themes/gruvbox-material.vim]])
    end,
  },

  {
    'romgrk/barbar.nvim',
    config = function()
      require('plugins.barbar').config()
    end,
    after = {'which-key.nvim'},
    -- event = 'BufWinEnter',
  },

  -- Debugging
  -- TODO: Could probably load these only on files that need debugging
  {
    'mfussenegger/nvim-dap',
    -- event = "BufWinEnter",
    config = function()
      require('plugins.dap.nvim-dap').config()
    end,
    requires = {
      {
        'rcarriga/nvim-dap-ui',
        config = function()
          require('plugins.dap.nvim-dap-ui').config()
        end,
      },
      'mfussenegger/nvim-dap-python',
    },
  },

  -- Debugger management
  -- TODO: Implement other DAP plugins
  -- {
  --   'Pocco81/DAPInstall.nvim',
  --   -- event = "BufWinEnter",
  --   -- event = "BufRead",
  --   disable = not lvim.builtin.dap.active,
  -- },

  -- Terminal
  -- {
  --   'akinsho/toggleterm.nvim',
  --   event = 'BufWinEnter',
  --   config = function()
  --     require('core.terminal').setup()
  --   end,
  --   disable = not lvim.builtin.terminal.active,
  -- },
  --
  {
    'iamcco/markdown-preview.nvim',
    config = function()
      require('plugins.markdown-preview').config()
    end,
    ft = 'md',
    run = 'cd app && yarn install',
  },
}
