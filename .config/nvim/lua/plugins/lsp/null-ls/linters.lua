local M = {}
local linters_by_ft = {}

local null_ls = require('null-ls')
local services = require('plugins.lsp.null-ls.services')
local Log = require('core.log')

local function list_names(linters, options)
  options = options or {}
  local filter = options.filter or 'supported'

  return vim.tbl_keys(linters[filter])
end

function M.list_supported_names(filetype)
  if not linters_by_ft[filetype] then
    return {}
  end
  return list_names(linters_by_ft[filetype], { filter = 'supported' })
end

function M.list_unsupported_names(filetype)
  if not linters_by_ft[filetype] then
    return {}
  end
  return list_names(linters_by_ft[filetype], { filter = 'unsupported' })
end

function M.list_available(filetype)
  local linters = {}
  for _, provider in pairs(null_ls.builtins.diagnostics) do
    -- TODO: Add support for wildcard filetypes
    if vim.tbl_contains(provider.filetypes or {}, filetype) then
      table.insert(linters, provider.name)
    end
  end

  return linters
end

function M.list_configured(linter_configs)
  local linters, errors = {}, {}

  for _, lnt_config in ipairs(linter_configs) do
    local linter = null_ls.builtins.diagnostics[lnt_config.exe]
    if not linter then
      Log:error('Not a valid linter: ' .. lnt_config.exe)
      errors[lnt_config.exe] = {} -- Add data here when necessary
    else
      local local_provider = lnt_config.local_provider or nil
      local linter_cmd = services.find_command(linter._opts.command, local_provider)
      if not linter_cmd then
        Log:warn('Not found: ' .. linter._opts.command)
        errors[lnt_config.exe] = {} -- Add data here when necessary
      else
        Log:debug('Using linter: ' .. linter_cmd)
        linters[lnt_config.exe] = linter.with({
          command = linter_cmd,
          extra_args = lnt_config.args,
          diagnostics_format = lnt_config.diagnostics_format or '[#{s}] #{m} (#{c})',
        })
      end
    end
  end

  return { supported = linters, unsupported = errors }
end

function M.setup(filetype, options)
  local ok, config = pcall(require, 'plugins.lsp.language-configs.' .. filetype)
  if not ok or not config.linters then
    return
  end

  linters_by_ft[filetype] = M.list_configured(config.linters)
  null_ls.register({ sources = linters_by_ft[filetype].supported })
end

return M
