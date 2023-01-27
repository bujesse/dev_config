local M = {}

local Log = require('core.log')

local function find_ts_root()
  local util = require('lspconfig/util')
  local lsp_utils = require('plugins.lsp.utils')

  local status_ok, ts_client = lsp_utils.is_client_active('typescript')
  if status_ok then
    return ts_client.config.root_dir
  end
  local dirname = vim.fn.expand('%:p:h')
  return util.root_pattern('package.json')(dirname)
end

-- Local Providers: Use these to specify where an executable lives

function M.from_nvim_venv(command)
  return PYTHON_NVIM_VENV .. '/' .. command
end

function M.from_node_modules(command)
  local root_dir = find_ts_root()

  if not root_dir then
    return nil
  end

  return root_dir .. '/node_modules/.bin/' .. command
end

local local_providers = {
  -- js, ts, json
  prettier = { find = M.from_node_modules },
  prettierd = { find = M.from_node_modules },
  prettier_d_slim = { find = M.from_node_modules },
  eslint_d = { find = M.from_node_modules },
  eslint = { find = M.from_node_modules },
  stylelint = { find = M.from_node_modules },

  -- Python
  black = { find = M.from_nvim_venv },
  flake8 = { find = M.from_nvim_venv },

  -- Custom
  darker = { find = M.from_nvim_venv },
}

function M.find_command(command)
  if local_providers[command] then
    local local_command = local_providers[command].find(command)
    if local_command and vim.fn.executable(local_command) == 1 then
      return local_command
    end
  end

  if command and vim.fn.executable(command) == 1 then
    return command
  end
  return nil
end

function M.register_custom_sources()
  local null_ls = require('null-ls')
  local helpers = require('null-ls.helpers')

  local darker = {
    name = 'darker',
    filetypes = { 'python' },
    method = { null_ls.methods.FORMATTING },
    meta = {
      url = 'https://github.com/akaihola/darker',
      description = [[
        Re-format Python source files by using
        - `isort` to sort Python import definitions alphabetically within logical sections
        - `black` to re-format code changed since the last Git commit

        Please run `pip install darker[isort]` to enable sorting of import definitions
      ]],
    },
    generator = helpers.formatter_factory({
      command = M.find_command('darker'),
      args = {
        '--quiet',
        '--isort',
        '--skip-string-normalization',
        '--stdout',
        '--line-length',
        '120',
        '$FILENAME',
      },
      to_stdin = false,
      from_stderr = true,
      -- to_temp_file = false,
      -- from_temp_file = true,
    }),
  }

  local is_registered = require('null-ls.sources').is_registered
  if not is_registered({ name = darker.name }) then
    null_ls.register(darker)
  end
end

function M.list_registered_providers_names(filetype)
  local s = require('null-ls.sources')
  local available_sources = s.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

function M.register_sources(configs, method)
  local null_ls = require('null-ls')
  local is_registered = require('null-ls.sources').is_registered

  local sources, registered_names = {}, {}

  for _, config in ipairs(configs) do
    local cmd = config.exe or config.command
    local name = config.name or cmd:gsub('-', '_')
    local type = method == null_ls.methods.CODE_ACTION and 'code_actions' or null_ls.methods[method]:lower()
    local source = type and null_ls.builtins[type][name]
    Log:debug(string.format('Received request to register [%s] as a %s source', name, type))
    if not source then
      Log:error('Not a valid source: ' .. name)
    elseif is_registered({ name = source.name or name, method = method }) then
      Log:trace(string.format('Skipping registering [%s] more than once', name))
    else
      local command = M.find_command(source._opts.command) or source._opts.command

      -- treat `args` as `extra_args` for backwards compatibility. Can otherwise use `generator_opts.args`
      local compat_opts = vim.deepcopy(config)
      if config.args then
        compat_opts.extra_args = config.args or config.extra_args
        compat_opts.args = nil
      end

      local opts = vim.tbl_deep_extend('keep', { command = command }, compat_opts)
      Log:debug('Registering source ' .. name)
      Log:trace(vim.inspect(opts))
      table.insert(sources, source.with(opts))
      vim.list_extend(registered_names, { source.name })
    end
  end

  if #sources > 0 then
    null_ls.register({ sources = sources })
  end

  return registered_names
end

return M
