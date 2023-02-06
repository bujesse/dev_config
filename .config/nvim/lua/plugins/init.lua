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
          package_uninstalled = '✗',
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
      },
    },
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
  },

  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup()
    end,
    dependencies = {
      'neovim/nvim-lspconfig',
    },
  },

  -- TODO
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      require('plugins.lsp.nvim-lspconfig').config()
    end,
    dependencies = {
      'neodev.nvim',
      'RRethy/vim-illuminate',
      'jose-elias-alvarez/null-ls.nvim',
      'b0o/schemastore.nvim',
      'jose-elias-alvarez/typescript.nvim',
    },
  },

  {
    'folke/neodev.nvim',
    opts = {
      library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = true,
        -- plugins = {
        --   'neotest',
        --   'plenary.nvim',
        --   'telescope.nvim',
        -- }, -- Was slow because the lsp was doing the formatting
      },
      lspconfig = true,
      pathStrict = true,
    },
    config = function() end,
  },

  -- UI for nvim-lsp
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({})
    end,
  },
}
