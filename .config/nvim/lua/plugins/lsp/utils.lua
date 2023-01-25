local M = {}
local Log = require('core.log')

function M.is_client_active(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == name then
      return true, client
    end
  end
  return false
end

-- Diagnostics Visibility
function M.toggle_diagnostics(should_log)
  M.diagnostics_visible = not M.diagnostics_visible

  local conf = {
    virtual_text = M.diagnostics_visible,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  }

  -- toggle the diagnostic settings
  vim.diagnostic.config(conf)

  if should_log then
    print('Diagnostics are ' .. (M.diagnostics_visible and 'ON' or 'OFF'))
  end
end

-- Autoformat
function M.turn_off_autoformat()
  vim.cmd([[
  if exists('#autoformat#BufWritePre')
    :autocmd! autoformat
    endif
    ]])
end

function M.turn_on_autoformat()
  require('core.autocommands').define_augroups({
    autoformat = {
      {
        'BufWritePre',
        '*',
        ':silent lua vim.lsp.buf.format()',
      },
    },
  })
end

function M.temp_off()
  M.turn_off_autoformat()
  M.autoformat_is_on = not M.autoformat_is_on
end

function M.toggle_autoformat(should_log)
  if M.autoformat_is_on then
    M.turn_off_autoformat()
  else
    M.turn_on_autoformat()
  end

  M.autoformat_is_on = not M.autoformat_is_on

  if should_log then
    print('Format on save ' .. (M.autoformat_is_on and 'ON' or 'OFF'))
  end
end

function M.setup()
  M.diagnostics_visible = not GLOBAL_CONFIG.diagnostics_visible
  M.autoformat_is_on = not GLOBAL_CONFIG.format_on_save

  M.toggle_autoformat(false)
  vim.keymap.set(
    'n',
    'yoa',
    '<cmd>lua require("plugins.lsp.utils").toggle_autoformat(1)<CR>',
    { noremap = true, silent = true }
  )

  -- Start with diagnostics off
  M.toggle_diagnostics(false)
  vim.keymap.set(
    'n',
    'yod',
    '<cmd>lua require("plugins.lsp.utils").toggle_diagnostics(1)<CR>',
    { noremap = true, silent = true }
  )
end

return M
