local null_ls_service = require('plugins.lsp.null-ls.services')

local M = {
  formatters = {
    {
      exe = 'darker',
      args = { '--line-length', '120', '--skip-string-normalization' },
      local_provider = null_ls_service.from_nvim_venv,
      diagnostics_format = '[darker] #{m} (#{c})',
    },
    -- {
    --   exe = 'black',
    --   args = { '--line-length', '120', '--skip-string-normalization' },
    --   local_provider = null_ls_service.from_nvim_venv,
    --   diagnostics_format = '[black] #{m} (#{c})',
    -- },
    -- {
    --   exe = 'autopep8',
    --   args = { '--aggressive', '--aggressive' },
    --   local_provider = null_ls_service.from_nvim_venv,
    --   diagnostics_format = '[autopep8] #{m} (#{c})',
    -- },
  },
  linters = {
    {
      exe = 'flake8',
      args = {},
      local_provider = null_ls_service.from_nvim_venv,
      diagnostics_format = '[flake8] #{m} (#{c})',
    },
  },
  lsp = {
    provider = 'pyright',
  },
}

return M
