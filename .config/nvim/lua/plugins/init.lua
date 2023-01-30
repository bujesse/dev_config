local M = {}

function M.config()
  require('lazy').setup({
    {
      'nvim-lua/plenary.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim',
        'jose-elias-alvarez/null-ls.nvim',
        'sindrets/diffview.nvim',
        'nvim-neo-tree/neo-tree.nvim',
      }
    },

    {
      'folke/which-key.nvim',
      config = function()
        require('plugins.which-key').config()
      end,
    },

    {
      'ellisonleao/gruvbox.nvim',
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        require('plugins.gruvbox').config()
      end,
    },

    {
      'mhinz/vim-startify',
      config = function()
        require('plugins.startify').config()
      end,
    },

    {
      'ThePrimeagen/harpoon',
      config = function()
        require('plugins.harpoon').config()
      end,
    },

    {
      'kyazdani42/nvim-web-devicons',
      config = function()
        require('plugins.nvim-web-devicons').config()
      end,
      dependencies = {
        {
          'romgrk/barbar.nvim',
          enabled = false,
          config = function()
            require('plugins.barbar').config()
          end,
        },
        'nvim-lualine/lualine.nvim',
        'akinsho/bufferline.nvim',
      }
    },

    {
      'nvim-lualine/lualine.nvim',
      config = function()
        require('plugins.lualine.init').config()
      end,
    },

    {
      'simrat39/symbols-outline.nvim',
      config = function()
        require('plugins.symbols-outline').config()
      end,
    },

    {
      'ojroques/nvim-bufdel',
      config = function()
        require('bufdel').setup({
          next = 'cycle', -- or 'cycle, 'alternate'
          quit = true, -- quit Neovim when last buffer is closed
        })
      end,
    },

    {
      'akinsho/bufferline.nvim',
      dependencies = {
        'ojroques/nvim-bufdel',
        'tiagovla/scope.nvim',
      },
      config = function()
        require('plugins.bufferline').config()
      end,
    },

    {
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('plugins.indent-blankline').config()
      end,
    },

    {
      'nvim-treesitter/nvim-treesitter',
      event = 'BufRead',
      build = ':TSUpdate',
      config = function()
        require('plugins.nvim-treesitter').config()
      end,
    },

    -- git stuff
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('plugins.gitsigns').config()
      end,
      dependencies = {
        {
          'petertriho/nvim-scrollbar',
          config = function()
            require('plugins.nvim-scrollbar').config()
          end,
        },
      },
    },

    {
      'sindrets/diffview.nvim',
      config = function()
        require('plugins.diffview').config()
      end,
    },

    -- smooth scroll
    {
      'karb94/neoscroll.nvim',
      config = function()
        require('plugins.neoscroll').config()
      end,
    },

    -- lsp stuff

    {
      'williamboman/mason.nvim',
      config = function()
        require('plugins.mason').config()
      end,
      dependencies = {
        'williamboman/mason-lspconfig.nvim'
      }
    },

    {
      'williamboman/mason-lspconfig.nvim',
      config = function()
        require('mason-lspconfig').setup()
      end,
      dependencies = {
        'neovim/nvim-lspconfig',
      }
    },

    {
      'neovim/nvim-lspconfig',
      config = function()
        require('plugins.lsp.nvim-lspconfig').config()
      end,
      dependencies = {
        'rrethy/vim-illuminate',
        'jose-elias-alvarez/null-ls.nvim',
      },
    },

    -- UI for nvim-lsp
    {
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup({})
      end,
    },

    {
      'folke/neodev.nvim',
    },

    -- load luasnips + cmp related in insert mode only
    {
      'onsails/lspkind-nvim',
      event = 'InsertEnter',
      dependencies = {
        'hrsh7th/nvim-cmp',
      }
    },

    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'windwp/nvim-autopairs',
      },
      config = function() require('plugins.nvim-cmp').config() end,
    },

    {
      'L3MON4D3/LuaSnip',
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = function()
        require('plugins.luasnip').config()
      end,
    },

    -- misc plugins
    {
      'windwp/nvim-autopairs',
      config = function()
        require('plugins.nvim-autopairs').config()
      end,
    },

    {
      'akinsho/toggleterm.nvim',
      version = '*',
      config = function()
        require('plugins.toggleterm').config()
      end,
    },

    --    ,'alvan/vim-closetag' -- for html autoclosing tag

    {
      'AckslD/nvim-neoclip.lua',
      enabled = false,
      dependencies = {
        'nvim-telescope/telescope.nvim',
      },
      config = function()
        require('plugins.neoclip').config()
      end,
    },

    {
      'gbprod/yanky.nvim',
      dependencies = {
        'nvim-telescope/telescope.nvim',
      },
      config = function()
        require('plugins.yanky').config()
      end,
    },

    {
      's1n7ax/nvim-window-picker',
      version = 'v1.*',
      config = function()
        require('window-picker').setup()
      end,
      dependencies = {
        'nvim-neo-tree/neo-tree.nvim',
      }
    },

    {
      'MunifTanjim/nui.nvim',
      dependencies = {
        'nvim-neo-tree/neo-tree.nvim',
      }
    },

    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = function()
        require('plugins.neo-tree').config()
      end,
    },

    {
      'nvim-telescope/telescope.nvim',
      config = function()
        require('plugins.telescope').config()
      end,
    },

    -- Debugging
    -- {
    --   'mfussenegger/nvim-dap',
    --   -- event = 'BufWinEnter',
    --   ft = { 'python' },
    --   config = function()
    --     require('plugins.nvim-dap').config()
    --   end,
    -- },

    -- {
    --   'Pocco81/DAPInstall.nvim',
    --   -- event = 'BufWinEnter',
    --   -- event = 'BufRead',
    -- },

    {
      -- cr_ to change between cases
      'tpope/vim-abolish',
      config = function()
        require('plugins.abolish').config()
      end,
    },

    {
      'numToStr/Comment.nvim',
      config = function()
        require('plugins.comment').config()
      end,
    },

    {
      'kevinhwang91/promise-async',
      dependencies = {
        'kevinhwang91/nvim-ufo',
      }
    },

    {
      'luukvbaal/statuscol.nvim',
      dependencies = {
        'kevinhwang91/nvim-ufo',
      }
    },

    {
      'kevinhwang91/nvim-ufo',
      config = function()
        require('plugins.nvim-ufo').config()
      end,
    },

    { 'tpope/vim-repeat' },

    {
      'kylechui/nvim-surround',
      -- version = '*', -- Use for stability; omit to use `main` branch for the latest features
      config = function()
        require('plugins.nvim-surround').config()
      end,
    },

    -- Text editing
    {
      'vim-scripts/ReplaceWithRegister',
      config = function()
        require('plugins.replace-with-register').config()
      end,
    },

    {
      'smjonas/inc-rename.nvim',
      config = function()
        require('inc_rename').setup()
        vim.keymap.set('n', 'gR', ':IncRename ')
      end,
    },

    {
      'kevinhwang91/nvim-bqf',
      ft = 'qf', -- filetype: quickfix
      dependencies = {
        {
          'junegunn/fzf',
          build = function()
            vim.fn['fzf#install']()
          end,
        },
      },
      config = function()
        require('plugins.bqf').config()
      end,
    },

    {
      'rhysd/clever-f.vim',
      config = function()
        require('plugins.clever-f').config()
      end,
    },

    {
      'ggandor/leap.nvim',
      config = function()
        require('plugins.leap').config()
      end,
    },

    {
      'haya14busa/vim-asterisk',
      config = function()
        require('plugins.vim-asterisk').config()
      end,
    },

    { 'tommcdo/vim-exchange' },
    { 'mg979/vim-visual-multi' },
    {
      'Wansmer/treesj',
      dependencies = { 'nvim-treesitter' },
      config = function()
        require('plugins.treesj').config()
      end,
    },

    -- Text objects
    { 'michaeljsmith/vim-indent-object' },
    { 'dbakker/vim-paragraph-motion' },
  },
    {
      ui = {
        icons = {
          cmd = "⌘",
          config = "🛠",
          event = "📅",
          ft = "📂",
          init = "⚙",
          keys = "🗝",
          plugin = "🔌",
          runtime = "💻",
          source = "📄",
          start = "🚀",
          task = "📌",
          lazy = "💤 ",
        }
      },
    })
end

return M
