local M = {}

M.symbols = function()
  local signs = { Error = '', Warn = '', Hint = '', Info = '', Other = '' }

  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

M.setup = function()
  M.symbols()
end

return M
