local M = {}

M.symbols = function()
  local signs = { Error = '', Warning = '', Hint = '', Information = '', Other = '﫠' }

  for type, icon in pairs(signs) do
    local hl = 'LspDiagnosticsSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

M.setup = function()
  M.symbols()
end

return M
