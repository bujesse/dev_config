local Log = require('core.log')

M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.common_on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = {
    noremap = true,
    silent = true,
  }

  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<Leader>af', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('i', '<C-_>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<C-_>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- See `:help vim.lsp.*` for documentation on functions

  -- Enable vim-illuminate
  require('illuminate').on_attach(client)
  vim.api.nvim_command([[ hi def link LspReferenceText CursorLine ]])
  vim.api.nvim_command([[ hi def link LspReferenceWrite CursorLine ]])
  vim.api.nvim_command([[ hi def link LspReferenceRead CursorLine ]])
  buf_set_keymap('x', ']r', 'm\'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
  buf_set_keymap('x', '[r', 'm\'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)
  buf_set_keymap('n', ']r', 'm\'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
  buf_set_keymap('n', '[r', 'm\'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)

  -- Setup lsp toggles
  require('plugins.lsp.utils').setup(buf_set_keymap)

  -- Setup formatters and linters
  require('plugins.lsp.null-ls').setup(vim.bo.filetype)

  -- Setup UI configuration
  require('plugins.lsp.ui').setup()
end

M.common_on_init = function(client, bufnr)
  local formatters = require('plugins.lsp.language-configs.' .. vim.bo.filetype).formatters
  if not vim.tbl_isempty(formatters) and formatters[1]['exe'] ~= nil and formatters[1].exe ~= '' then
    client.resolved_capabilities.document_formatting = false
    Log:debug(
      string.format('Overriding language server [%s] with format provider [%s]', client.name, formatters[1].exe)
    )
  end
end

M.common_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if not status_ok then
    return capabilities
  end
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  return capabilities
end

M.make_config = function(server)
  local ok, config = pcall(require, 'plugins.lsp.language-configs.' .. server)
  if ok and config.lsp and config.lsp.setup then
    config = config.lsp.setup
  else
    config = {}
  end

  config.on_attach = function(client, bufnr)
    if config.before_on_attach then
      config.before_on_attach(client, bufnr)
    end
    M.common_on_attach(client, bufnr)
    if config.after_on_attach then
      config.after_on_attach(client, bufnr)
    end
  end

  if not config.on_init then
    config.on_init = M.common_on_init
  end
  if not config.capabilities then
    config.capabilities = M.common_capabilities()
  end

  return config
end

-- lsp-install
M.setup_servers = function()
  require('lspinstall').setup()

  -- get all installed servers
  local servers = require('lspinstall').installed_servers()
  for _, server in pairs(servers) do
    local config = M.make_config(server)
    require('lspconfig')[server].setup(config)
  end
end

M.config = function()
  require('lspconfig')
  M.setup_servers()

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  require('lspinstall').post_install_hook = function()
    M.setup_servers() -- reload installed servers
    vim.cmd('bufdo e') -- this triggers the FileType autocmd that starts the server
  end
end

return M
