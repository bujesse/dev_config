local M = {}

function M.config()
  -- vim.o.clipboard = 'unnamed'

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

  -- vim.cmd([[set shell=/usr/local/bin/fish]])
  -- vim.cmd([[
  --   let g:clipboard = {
  --                 \   'name': 'WslClipboard',
  --                 \   'copy': {
  --                 \      '+': 'clip.exe',
  --                 \      '*': 'clip.exe',
  --                 \    },
  --                 \   'paste': {
  --                 \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  --                 \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  --                 \   },
  --                 \   'cache_enabled': 0,
  --                 \ }
  -- ]])

  -- This is necesary for copying to a clipboard outside of VAGRANT
  -- vim.cmd([[
  --   let g:clipboard = {
  --         \   'name': 'cbcopy',
  --         \   'copy': {
  --         \      '+': ['/home/vagrant/.config/nvim/scripts/copy.sh'],
  --         \      '*': ['/home/vagrant/.config/nvim/scripts/copy.sh'],
  --         \    },
  --         \   'paste': {
  --         \      '+': 'echo',
  --         \      '*': 'echo',
  --         \   },
  --         \   'cache_enabled': 1,
  --         \ }
  -- ]])
end

return M
