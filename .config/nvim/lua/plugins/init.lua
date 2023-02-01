return {

  -- lsp stuff

  {
    'williamboman/mason.nvim',
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗'
        },
        keymaps = {
          toggle_package_expand = '<CR>',
          install_package = 'i',
          update_package = 'u',
          check_package_version = 'v',
          update_all_packages = 'U',
          check_outdated_packages = 'c',
          uninstall_package = 'x',
          cancel_installation = '<C-c>',
          apply_language_filter = '<C-f>',
        },
      }
    },
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

  -- TODO
  {
    'neovim/nvim-lspconfig',
    event = "BufReadPre",
    config = function()
      require('plugins.lsp.nvim-lspconfig').config()
    end,
    dependencies = {
      {
        "folke/neodev.nvim",
        opts = {
          library = {
            -- buildtime = false,
            -- types = false,
            plugins = {
              'plenary.nvim',
              'telescope.nvim',
              'null-ls',
            }, -- this one makes it slow; probably because i have too many i guess. Can use a table here if i want access to certain plugins. In fact it's probably just a few bad plugins making it slow
          },
          pathStrict = true,
          experimental = { pathStrict = true },
        }
      },
      'RRethy/vim-illuminate',
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

}
