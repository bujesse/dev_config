local M = {}

function M.config()
  local present, packer = pcall(require, 'core.packer-init')
  if not present then
    return false
  end

  local use = packer.use

  return packer.startup(function()
    -- this is arranged on the basis of when a plugin starts
    use({ 'nvim-lua/plenary.nvim' })
    -- use({ 'romgrk/fzy-lua-native' })

    use({ 'lewis6991/impatient.nvim' })

    use({
      'wbthomason/packer.nvim',
      event = 'VimEnter',
    })

    use({
      'folke/which-key.nvim',
      config = function()
        require('plugins.which-key').config()
      end,
    })

    use({
      'ellisonleao/gruvbox.nvim',
      config = function()
        require('plugins.gruvbox').config()
      end,
    })


    use({
      'mhinz/vim-startify',
      config = function()
        require('plugins.startify').config()
      end,
    })

    use({
      'ThePrimeagen/harpoon',
      config = function()
        require('plugins.harpoon').config()
      end,
    })

    use({
      'kyazdani42/nvim-web-devicons',
      config = function()
        require('plugins.nvim-web-devicons').config()
      end,
    })

    use({
      'nvim-lualine/lualine.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons',
        opt = true,
      },
      config = function()
        require('plugins.lualine.init').config()
      end,
    })

    use({
      'stevearc/aerial.nvim',
      config = function()
        require('plugins.aerial').config()
      end
    })

    use({
      'petertriho/nvim-scrollbar',
      after = { 'gitsigns.nvim' },
      config = function()
        require('plugins.nvim-scrollbar').config()
      end
    })

    use({
      'datwaft/bubbly.nvim',
      disable = true,
      requires = {
        'kyazdani42/nvim-web-devicons',
      },
      -- after = {
      --   'gruvbox-material',
      -- },
      config = function()
        require('plugins.bubbly').config()
      end,
    })

    use({
      'ojroques/nvim-bufdel',
      config = function()
        require('bufdel').setup {
          next = 'cycle', -- or 'cycle, 'alternate'
          quit = true, -- quit Neovim when last buffer is closed
        }
      end,
    })

    use({
      'akinsho/bufferline.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons',
        'ojroques/nvim-bufdel'
      },
      config = function()
        require('plugins.bufferline').config()
      end,
    })
    use({
      'romgrk/barbar.nvim',
      after = 'nvim-web-devicons',
      disable = true,
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

    use({
      'nvim-treesitter/nvim-treesitter',
      event = 'BufRead',
      run = ':TSUpdate',
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
      requires = { 'plenary.nvim' },
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
        'williamboman/nvim-lsp-installer',
        'rrethy/vim-illuminate',
      },
    })

    use({
      'jose-elias-alvarez/null-ls.nvim',
      -- config is in lspconfig
      after = {
        'plenary.nvim',
        -- 'nvim-lspconfig',
      },
    })

    -- Show function signature when you type
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

    -- load luasnips + cmp related in insert mode only
    use({
      'onsails/lspkind-nvim',
      event = 'InsertEnter',
    })

    use({
      'hrsh7th/nvim-cmp',
      after = { 'lspkind-nvim' },
      requires = { 'LuaSnip' },
      config = function()
        require('plugins.nvim-cmp').config()
      end,
    })

    use({
      'L3MON4D3/LuaSnip',
      requires = { 'rafamadriz/friendly-snippets' },
      config = function()
        require('plugins.luasnip').config()
      end,
    })

    use({
      'saadparwaiz1/cmp_luasnip',
      after = 'nvim-cmp',
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

    use({
      'akinsho/toggleterm.nvim',
      tag = '*',
      config = function()
        require('plugins.toggleterm').config()
      end,
    })

    --   use 'alvan/vim-closetag' -- for html autoclosing tag

    use {
      'AckslD/nvim-neoclip.lua',
      disable = true,
      requires = {
        { 'nvim-telescope/telescope.nvim' },
      },
      config = function()
        require('plugins.neoclip').config()
      end,
    }

    use {
      'gbprod/yanky.nvim',
      requires = {
        { 'nvim-telescope/telescope.nvim' },
      },
      config = function()
        require('plugins.yanky').config()
      end,
    }

    use {
      's1n7ax/nvim-window-picker',
      tag = 'v1.*',
      config = function()
        require 'window-picker'.setup()
      end,
    }

    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        's1n7ax/nvim-window-picker',
      },
      config = function()
        require('plugins.neo-tree').config()
      end,
    })

    use({
      'nvim-telescope/telescope.nvim',
      config = function()
        require('plugins.telescope').config()
      end,
    })

    -- Debugging
    -- use({
    --   'mfussenegger/nvim-dap',
    --   -- event = 'BufWinEnter',
    --   ft = { 'python' },
    --   config = function()
    --     require('plugins.nvim-dap').config()
    --   end,
    -- })

    -- use({
    --   'Pocco81/DAPInstall.nvim',
    --   -- event = 'BufWinEnter',
    --   -- event = 'BufRead',
    -- })

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

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('plugins.comment').config()
      end
    }

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
      'ggandor/leap.nvim',
      config = function()
        require('plugins.leap').config()
      end,
    })

    use({
      'haya14busa/vim-asterisk',
      config = function()
        require('plugins.vim-asterisk').config()
      end,
    })

    use({ 'tommcdo/vim-exchange' })
    use({ 'mg979/vim-visual-multi' })
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
end

return M
