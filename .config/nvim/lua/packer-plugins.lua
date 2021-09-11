return {
  -- Packer can manage itself as an optional plugin
  { 'wbthomason/packer.nvim' },
  {
    'folke/which-key.nvim',
    config = require('plugins.which-key').config,
    event = 'BufWinEnter',
  },
  { 'neovim/nvim-lspconfig' },
  { 'rrethy/vim-illuminate' },
  { 'tamago324/nlsp-settings.nvim' },
  { 'jose-elias-alvarez/null-ls.nvim' },
  { 'antoinemadec/FixCursorHold.nvim' }, -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  {
    'kabouzeid/nvim-lspinstall',
    event = 'VimEnter',
    config = require('plugins.lsp.nvim-lspconfig').config,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    branch = '0.5-compat',
    config = require('plugins.nvim-treesitter').config,
    run = ':TSUpdate',
    after = {
      'which-key.nvim',
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = '0.5-compat',
    after = 'nvim-treesitter',
  },

  { 'nvim-lua/plenary.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    config = require('plugins.telescope').config,
    after = 'which-key.nvim',
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
    config = require('plugins.nvim-cmp').config,
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
    config = require('plugins.nvim-autopairs').config,
  },

  {
    'kyazdani42/nvim-tree.lua',
    -- event = "BufWinOpen",
    -- cmd = "NvimTreeToggle",
    config = require('plugins.nvim-tree').config,
  },

  {
    'lewis6991/gitsigns.nvim',
    config = require('plugins.gitsigns').config,
    event = 'BufRead',
  },

  -- Tpope
  -- crs and crc to change between cases; text replacement (e.g. facilities -> buildings)
  {
    'tpope/vim-abolish',
    config = require('plugins.abolish').config,
    after = 'which-key.nvim',
  },
  -- gc to toggle comments
  { 'tpope/vim-commentary' },
  -- git wrapper
  {
    'tpope/vim-fugitive',
    config = require('plugins.vim-fugitive').config,
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
    config = require('plugins.replace-with-register').config,
  },
  {
    'rhysd/clever-f.vim',
    config = require('plugins.clever-f').config,
  },
  {
    'phaazon/hop.nvim',
    config = require('plugins.hop').config,
  },
  {
    'haya14busa/vim-asterisk',
    config = require('plugins.vim-asterisk').config,
  },
  {
    -- swap 2 text objects
    'tommcdo/vim-exchange',
  },
  {
    -- Align text around a chosen character
    'junegunn/vim-easy-align',
    config = require('plugins.vim-easy-align').config,
  },
  {
    -- Multiple cursors
    'mg979/vim-visual-multi',
  },
  {
    -- keep yank history and cycle through
    'svermeulen/vim-yoink',
    config = require('plugins.vim-yoink').config,
  },
  {
    -- expand one-liner multi-line
    'AndrewRadev/splitjoin.vim',
    config = require('plugins.splitjoin').config,
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
    config = require('plugins.lualine').config,
    after = 'gruvbox-material',
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    config = require('plugins.indent-blankline').config,
  },
  {
    'karb94/neoscroll.nvim',
    config = require('plugins.neoscroll').config,
  },

  { 'onsails/lspkind-nvim' },

  {
    'mhinz/vim-startify',
    config = require('plugins.startify').config,
  },

  {
    'sainnhe/gruvbox-material',
    config = function()
      vim.cmd([[source ~/.config/nvim/core/themes/gruvbox-material.vim]])
    end,
  },

  {
    'romgrk/barbar.nvim',
    config = require('plugins.barbar').config,
    after = 'which-key.nvim',
    event = 'BufWinEnter',
  },

  -- Debugging
  -- TODO: Could probably load these only on files that need debugging
  {
    'mfussenegger/nvim-dap',
    -- event = "BufWinEnter",
    config = require('plugins.dap.nvim-dap').config,
    requires = {
      {
        'rcarriga/nvim-dap-ui',
        config = require('plugins.dap.nvim-dap-ui').config,
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
    config = require('plugins.markdown-preview').config,
    cmd = 'MarkdownPreviewToggle',
    run = 'cd app && yarn install',
  },
}
