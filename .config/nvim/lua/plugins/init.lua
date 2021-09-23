local present, packer = pcall(require, 'core.packer-init')
if not present then
  return false
end

local use = packer.use

return packer.startup(function()
  -- this is arranged on the basis of when a plugin starts
  use({ 'nvim-lua/plenary.nvim' })
  -- use({ 'romgrk/fzy-lua-native' })

  use({
    'wbthomason/packer.nvim',
    event = 'VimEnter',
  })

  -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  use({ 'antoinemadec/FixCursorHold.nvim' })

  use({
    'folke/which-key.nvim',
    config = function()
      require('plugins.which-key').config()
    end,
  })

  use({
    'sainnhe/gruvbox-material',
    config = function()
      vim.cmd([[source ~/.config/nvim/core/themes/gruvbox-material.vim]])
    end,
  })

  use({
    'mhinz/vim-startify',
    config = function()
      require('plugins.startify').config()
    end,
  })

  use({
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('plugins.nvim-web-devicons').config()
    end,
  })

  use({
    'shadmansaleh/lualine.nvim',
    after = {
      'nvim-web-devicons',
      'gruvbox-material',
    },
    config = function()
      require('plugins.lualine.init').config()
    end,
  })

  use({
    'romgrk/barbar.nvim',
    after = 'nvim-web-devicons',
    config = function()
      require('plugins.barbar').config()
    end,
  })

  use({
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    config = function()
      require('plugins.indent-blankline').config()
    end,
  })

  -- use({
  --   'norcalli/nvim-colorizer.lua',
  --   event = 'BufRead',
  --   config = function()
  --     require('plugins.configs.others').colorizer()
  --   end,
  -- })

  use({
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    config = function()
      require('plugins.nvim-treesitter').config()
    end,
  })

  -- git stuff
  use({
    'lewis6991/gitsigns.nvim',
    config = function()
      require('plugins.gitsigns').config()
    end,
    setup = function()
      require('core.utils').packer_lazy_load('gitsigns.nvim')
    end,
  })

  -- smooth scroll
  use({
    'karb94/neoscroll.nvim',
    config = function()
      require('plugins.neoscroll').config()
    end,
    setup = function()
      require('core.utils').packer_lazy_load('neoscroll.nvim')
    end,
  })

  -- lsp stuff

  use({
    'neovim/nvim-lspconfig',
    setup = function()
      require('core.utils').packer_lazy_load('nvim-lspconfig')
      -- reload the current file so lsp actually starts for it
      vim.defer_fn(function()
        vim.cmd('silent! e %')
      end, 0)
    end,
    config = function()
      require('plugins.lsp.nvim-lspconfig').config()
    end,
    requires = {
      'kabouzeid/nvim-lspinstall',
      'rrethy/vim-illuminate',
    },
  })

  use({
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('plugins.lsp.null-ls').config()
    end,
    after = {
      'plenary.nvim',
      'nvim-lspconfig',
    },
  })

  -- use({
  --   'ray-x/lsp_signature.nvim',
  --   disable = not plugin_status.lspsignature,
  --   after = 'nvim-lspconfig',
  --   config = function()
  --     require('plugins.configs.others').signature()
  --   end,
  -- })

  -- use({
  --   'andymass/vim-matchup',
  --   disable = not plugin_status.vim_matchup,
  --   opt = true,
  --   setup = function()
  --     require('core.utils').packer_lazy_load('vim-matchup')
  --   end,
  -- })

  -- load autosave only if its globally enabled
  -- use({
  --   disable = not plugin_status.autosave,
  --   'Pocco81/AutoSave.nvim',
  --   config = function()
  --     require('plugins.configs.others').autosave()
  --   end,
  --   cond = function()
  --     return require('core.utils').load_config().options.plugin.autosave == true
  --   end,
  -- })

  -- load luasnips + cmp related in insert mode only
  use({
    'onsails/lspkind-nvim',
    event = 'InsertEnter',
  })

  use({
    'rafamadriz/friendly-snippets',
    event = 'InsertEnter',
  })

  use({
    'hrsh7th/nvim-cmp',
    after = { 'friendly-snippets', 'lspkind-nvim' },
    config = function()
      require('plugins.nvim-cmp').config()
    end,
  })

  use({
    'L3MON4D3/LuaSnip',
    wants = 'friendly-snippets',
    after = 'nvim-cmp',
    config = function()
      require('plugins.luasnip').config()
    end,
  })

  use({
    'saadparwaiz1/cmp_luasnip',
    after = 'LuaSnip',
  })

  use({
    'hrsh7th/cmp-nvim-lua',
    after = 'cmp_luasnip',
  })

  use({
    'hrsh7th/cmp-nvim-lsp',
    after = 'cmp-nvim-lua',
  })

  use({
    'hrsh7th/cmp-buffer',
    after = 'cmp-nvim-lsp',
  })

  use({
    'hrsh7th/cmp-path',
    after = 'cmp-buffer',
  })

  -- misc plugins
  use({
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function()
      require('plugins.nvim-autopairs').config()
    end,
  })

  -- use({
  --   'glepnir/dashboard-nvim',
  --   disable = not plugin_status.dashboard,
  --   config = function()
  --     require('plugins.configs.dashboard')
  --   end,
  --   setup = function()
  --     require('core.mappings').dashboard()
  --   end,
  -- })

  -- use({
  --   'sbdchd/neoformat',
  --   disable = not plugin_status.neoformat,
  --   cmd = 'Neoformat',
  --   setup = function()
  --     require('core.mappings').neoformat()
  --   end,
  -- })

  --   use "alvan/vim-closetag" -- for html autoclosing tag
  -- use({
  --   'terrortylor/nvim-comment',
  --   disable = not plugin_status.comment,
  --   cmd = 'CommentToggle',
  --   config = function()
  --     require('plugins.configs.others').comment()
  --   end,
  --   setup = function()
  --     require('core.mappings').comment()
  --   end,
  -- })

  -- file managing , picker etc
  use({
    'kyazdani42/nvim-tree.lua',
    -- cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    config = function()
      require('plugins.nvim-tree').config()
    end,
  })

  use({
    'nvim-telescope/telescope.nvim',
    -- cmd = 'Telescope',
    requires = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
      {
        'nvim-telescope/telescope-frecency.nvim',
        requires = { 'tami5/sqlite.lua' },
      },
    },
    config = function()
      require('plugins.telescope').config()
    end,
  })

  -- Tpope
  use({
    'tpope/vim-fugitive',
    cmd = {
      'Git',
      'Gdiff',
      'Gdiffsplit',
      'Gvdiffsplit',
      'Gwrite',
      'Gw',
    },
  })

  use({
    -- cr_ to change between cases
    'tpope/vim-abolish',
    config = function()
      require('plugins.abolish').config()
    end,
  })

  use({ 'tpope/vim-commentary' })
  use({ 'tpope/vim-repeat' })
  use({ 'tpope/vim-surround' })

  -- Text editing
  use({
    'vim-scripts/ReplaceWithRegister',
    -- Before load because the plugin checks if a mapping exists
    setup = function()
      require('plugins.replace-with-register').config()
    end,
  })
  use({
    'rhysd/clever-f.vim',
    config = function()
      require('plugins.clever-f').config()
    end,
  })
  use({
    'phaazon/hop.nvim',
    config = function()
      require('plugins.hop').config()
    end,
  })
  use({
    'haya14busa/vim-asterisk',
    config = function()
      require('plugins.vim-asterisk').config()
    end,
  })
  use({ 'tommcdo/vim-exchange' })
  use({
    'junegunn/vim-easy-align',
    config = function()
      require('plugins.vim-easy-align').config()
    end,
  })
  use({ 'mg979/vim-visual-multi' })
  use({
    'svermeulen/vim-yoink',
    config = function()
      require('plugins.vim-yoink').config()
    end,
  })
  use({
    'AndrewRadev/splitjoin.vim',
    config = function()
      require('plugins.splitjoin').config()
    end,
  })

  -- Text objects
  use({ 'michaeljsmith/vim-indent-object' })
  use({ 'dbakker/vim-paragraph-motion' })
end)
