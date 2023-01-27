local M = {}

local Log = require('core.log')

function M.config()
  local null_status_ok, null_ls = pcall(require, 'null-ls')
  if not null_status_ok then
    Log:error('Missing null-ls dependency')
    return
  end

  local lsp_config = require('plugins.lsp.nvim-lspconfig')
  local default_opts = lsp_config.get_common_opts()
  null_ls.setup(vim.tbl_deep_extend('force', default_opts, {
    debug = true,
  }))
end

function M.setup(options)
  options = options
      or {
        diagnostics_format = '[#{s}] #{m} (#{s})',
        debounce = 250,
        default_timeout = 5000,
      }

  local ok, _ = pcall(require, 'null-ls')
  if not ok then
    require('core.log'):error('Missing null-ls dependency')
    return
  end

  local formatters = require('plugins.lsp.null-ls.formatters')
  local linters = require('plugins.lsp.null-ls.linters')

  formatters.setup({
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
    --   exe = 'darker',
    --   args = { '-S', '-l', '120' },
    --   diagnostics_format = '[darker] #{m} (#{c})',
    -- },
    {
      exe = 'prettier',
    },
  })

  linters.setup({
    {
      exe = 'flake8',
      filetypes = { 'python' },
      diagnostics_format = '[flake8] #{m} (#{c})',
    },
    {
      exe = 'eslint',
    },
  })
end

return M
