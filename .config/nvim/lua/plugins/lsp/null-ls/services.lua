local M = {}

local function find_ts_root()
  local util = require("lspconfig/util")
  local lsp_utils = require("lsp.utils")

  local status_ok, ts_client = lsp_utils.is_client_active("typescript")
  if status_ok then
    return ts_client.config.root_dir
  end
  local dirname = vim.fn.expand("%:p:h")
  return util.root_pattern("package.json")(dirname)
end

-- Local Providers: Use these to specify where an executable lives

function M.from_nvim_venv(command)
  return PYTHON_NVIM_VENV .. "/" .. command
end

function M.from_node_modules(command)
  local root_dir = find_ts_root()

  if not root_dir then
    return nil
  end

  return root_dir .. "/node_modules/.bin/" .. command
end

-- local local_providers = {
--   prettier = { find = from_node_modules },
--   prettierd = { find = from_node_modules },
--   prettier_d_slim = { find = from_node_modules },
--   eslint_d = { find = from_node_modules },
--   eslint = { find = from_node_modules },
-- }

function M.find_command(command, local_provider)
  if local_provider then
    local local_command = local_provider(command)

    if local_command and vim.fn.executable(local_command) == 1 then
      return local_command
    end
  end

  if vim.fn.executable(command) == 1 then
    return command
  end
  return nil
end

return M
