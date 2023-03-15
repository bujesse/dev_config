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

      require('neodev').setup({
        override = function(root_dir, library)
          -- TODO: Configure to turn these on when in lua development; doesn't work for plugin dirs
          -- library.enabled = true
          -- library.plugins = true
        end,
        library = {
          enabled = true,
          runtime = true,
          types = true,
          -- plugins = false,
          plugins = {
            'neotest',
            'plenary.nvim',
            'null-ls',
            'telescope.nvim',
          }, -- Was slow because the lsp was doing the formatting
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
      'ray-x/lsp_signature.nvim',
    },
  },

  {
    'dnlhc/glance.nvim',
    opts = {
      folds = {
        folded = false, -- Automatically unfold list on startup
      },
      hooks = {
        before_open = function(results, open, jump, method)
          if method == 'references' and #results == 2 then
            -- If 2 references, then jump to the other reference
            local curr_line = unpack(vim.api.nvim_win_get_cursor(0))
            for i, ref in ipairs(results) do
              if ref.range.start.line + 1 == curr_line then
                jump(results[i % 2 + 1])
                return
              end
            end
            open(results)
          elseif #results == 1 then
            jump(results[1])
            return
          end
          open(results)
        end,
      },
    },
    keys = {
      { 'gd', '<CMD>Glance definitions<CR>', desc = 'Glance definitions' },
      { 'gr', '<CMD>Glance references<CR>', desc = 'Glance references' },
      { 'gy', '<CMD>Glance type_definitions<CR>', desc = 'Glance type_definitions' },
      { 'gm', '<CMD>Glance implementations<CR>', desc = 'Glance implementations' },
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
