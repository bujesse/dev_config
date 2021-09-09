local M = {
  formatters = {
    {
      exe = 'autopep8',
      args = { '--aggressive', '--aggressive' },
      local_provider = require('plugins.lsp.null-ls.services').from_nvim_venv,
      diagnostics_format = '[autopep8] #{m} (#{c})',
    },
  },
  linters = {
    {
      exe = 'flake8',
      args = {},
      local_provider = require('plugins.lsp.null-ls.services').from_nvim_venv,
      diagnostics_format = '[flake8] #{m} (#{c})',
    },
  },
  lsp = {
    provider = 'pyright',
    setup = {
      cmd = {
        DATA_PATH .. '/lspinstall/python/node_modules/.bin/pyright-langserver',
        '--stdio',
      },
    },
  },
}

return M
