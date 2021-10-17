local M = {}

function M.config()
  local null_status_ok, null_ls = pcall(require, "null-ls")
  if null_status_ok then
    null_ls.config({})
  end
  require'lspconfig'["null-ls"].setup({})
end

function M.list_supported_provider_names(filetype)
  local names = {}

  local formatters = require "lsp.null-ls.formatters"
  local linters = require "lsp.null-ls.linters"

  vim.list_extend(names, formatters.list_supported_names(filetype))
  vim.list_extend(names, linters.list_supported_names(filetype))

  return names
end

function M.list_unsupported_provider_names(filetype)
  local names = {}

  local formatters = require "lsp.null-ls.formatters"
  local linters = require "lsp.null-ls.linters"

  vim.list_extend(names, formatters.list_unsupported_names(filetype))
  vim.list_extend(names, linters.list_unsupported_names(filetype))

  return names
end

-- TODO: for linters and formatters with spaces and '-' replace with '_'
function M.setup(client, filetype, options)
  options = options or {
    diagnostics_format = "[#{s}] #{m} (#{s})",
    debounce = 250,
    default_timeout = 5000,
  }

  local ok, _ = pcall(require, "null-ls")
  if not ok then
    require("core.log"):error "Missing null-ls dependency"
    return
  end

  local formatters = require "plugins.lsp.null-ls.formatters"
  local linters = require "plugins.lsp.null-ls.linters"

  formatters.setup(client, filetype, options)
  linters.setup(client, filetype, options)
end

return M
