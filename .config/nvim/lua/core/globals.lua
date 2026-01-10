local M = {}

function M.config()
  vim.o.clipboard = 'unnamedplus'

  vim.g.python3_host_prog = '~/.pyenv/versions/nvim/bin/python'

  -- Disable python 2
  vim.g.loaded_python_provider = 0
  vim.g.python_pep8_indent_searchpair_timeout = 10

  -- Lua globals
  CONFIG_PATH = vim.fn.stdpath('config')
  DATA_PATH = vim.fn.stdpath('data')
  CACHE_PATH = vim.fn.stdpath('cache')
  TERMINAL = vim.fn.expand('$TERMINAL')
  USER = vim.fn.expand('$USER')
  PYTHON_NVIM_VENV, _ = vim.fn.expand(string.gsub(vim.g.python3_host_prog, '/[^/]*$', ''))

  GLOBAL_CONFIG = {
    format_on_save = true,
    diagnostics_visible = false,
  }

  -- https://github.com/equalsraf/win32yank/releases
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
end

return M
