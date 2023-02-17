return {

  -- lsp stuff

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

  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'jay-babu/mason-null-ls.nvim',
    },
  },

  -- TODO
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      require('mason').setup({
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
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'pyright',
          'tsserver',
          'jsonls',
        },
      })

      require('mason-null-ls').setup({
        ensure_installed = {
          'stylua',
          'ruff',
          'prettier',
          'yamllint',
        },
      })

      require('neodev').setup({
        override = function(root_dir, library)
          -- TODO: Configure to turn these on when in lua development; doesn't work for plugin dirs
          library.enabled = true
          library.plugins = true
        end,
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
      })

      -- Initialize all mason plugins and neodev before calling lsp setup
      require('plugins.lsp.nvim-lspconfig').config()
    end,
    dependencies = {
      'mason-lspconfig.nvim',
      'neodev.nvim',
      'RRethy/vim-illuminate',
      'jose-elias-alvarez/null-ls.nvim',
      'b0o/schemastore.nvim',
      'jose-elias-alvarez/typescript.nvim',
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
