local M = {}

local Log = require('core.log')

function M.config()
  local null_status_ok, null_ls = pcall(require, 'null-ls')
  if not null_status_ok then
    Log:error('Missing null-ls dependency')
    return
  end

  require('mason-null-ls').setup({
    ensure_installed = {
      'markdownlint',
      'sqlfluff',

      -- python
      -- 'basedpyright',
      'ty',
      'debugpy',
      'ruff',
      'blackd-client',

      -- golang
      'delve', -- go debugger
      'gopls',
      'templ',

      'stylua',
      -- 'ruff',
      -- 'prettier',
      -- 'yamllint',
    },
    handlers = {
      -- ruff_lsp = function(source_name, methods)
      --   null_ls.register(null_ls.builtins.diagnostics.ruff)
      -- end,
      stylua = function(source_name, methods)
        null_ls.register(null_ls.builtins.formatting.stylua.with({
          extra_args = {
            '--indent-type',
            'Spaces',
            '--indent-width',
            '2',
            '--quote-style',
            'AutoPreferSingle',
          },
        }))
      end,
      prettier = function(source_name, methods)
        null_ls.register(null_ls.builtins.formatting.prettier.with({
          disabled_filetypes = { 'markdown' },
        }))
      end,
      yamllint = function(source_name, methods)
        null_ls.register(null_ls.builtins.diagnostics.yamllint.with({
          extra_args = {
            '-d',
            [[{extends: relaxed, rules: {line-length: {max: 120}}}]],
          },
        }))
      end,
      sqlfluff = function(source_name, methods)
        local dialect = 'mysql'
        null_ls.register(null_ls.builtins.diagnostics.sqlfluff.with({
          extra_args = { '--dialect', dialect },
        }))
      end,
      ['sql-formatter'] = function(source_name, methods)
        require('mason-null-ls').default_setup(source_name, methods) -- to maintain default behavior
      end,
      ['djlint'] = function(source_name, methods)
        null_ls.register(null_ls.builtins.formatting.djlint)
        null_ls.register(null_ls.builtins.diagnostics.djlint)
      end,
    },
  })

  vim.api.nvim_create_user_command('NullLsToggle', function()
    require('null-ls').toggle({})
  end, {})

  vim.api.nvim_create_user_command('NullLsRestart', function()
    require('null-ls').toggle({})
    require('null-ls').toggle({})
  end, {})

  -- Then, anything not supported by mason-null-ls, use null-ls
  local lsp_config = require('plugins.lsp.nvim-lspconfig')
  local default_opts = lsp_config.get_common_opts()

  null_ls.setup(vim.tbl_deep_extend('force', default_opts, {
    diagnostics_format = '[#{s}] #{m} (#{s})',
  }))
  M.setup_null_ls()
end

function M.setup_null_ls()
  local ok, _ = pcall(require, 'null-ls')
  if not ok then
    require('core.log'):error('Missing null-ls dependency')
    return
  end

  local formatters = require('plugins.lsp.null-ls.formatters')
  local linters = require('plugins.lsp.null-ls.linters')

  -- use this for null-ls builtins only
  formatters.setup({
    -- {
    --   exe = 'black',
    --   timeout = 10000,
    --   args = {
    --     '--fast',
    --   },
    -- },
    {
      exe = 'stylua',
      args = {
        '--indent-type',
        'Spaces',
        '--indent-width',
        '2',
        '--quote-style',
        'AutoPreferSingle',
      },
    },
    -- {
    --   exe = 'prettier',
    -- },
  })

  linters.setup({
    -- {
    --   exe = 'flake8',
    --   filetypes = { 'python' },
    --   diagnostics_format = '[flake8] #{m} (#{c})',
    -- },
    -- {
    --   exe = 'ruff',
    --   filetypes = { 'python' },
    --   diagnostics_format = '[ruff] #{m} (#{c})',
    -- },
    -- {
    --   exe = 'eslint',
    -- },
  })
end

return M
