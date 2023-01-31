local M = {}

local null_ls = require('null-ls')
local services = require('plugins_new.lsp.null-ls.services')
local method = null_ls.methods.FORMATTING
local Log = require('core.log')

function M.list_registered(filetype)
  local registered_providers = services.list_registered_providers_names(filetype)
  return registered_providers[method] or {}
end

function M.setup(formatter_configs)
  if vim.tbl_isempty(formatter_configs) then
    return
  end

  local registered = services.register_sources(formatter_configs, method)
  services.register_custom_sources()

  if #registered > 0 then
    Log:debug('Registered the following formatters: ' .. unpack(registered))
  end
end

return M
