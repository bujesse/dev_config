local Log = require('core.log')

M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.common_on_attach = function(client, bufnr)
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

  vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.keymap.set('n', 'gq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.keymap.set('n', '<Leader>af', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('i', '<C-_>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', '<C-_>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', 'gh', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.keymap.set('n', 'gp', '<cmd>lua require"plugins.lsp.peek".Peek("definition")<CR>', opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.keymap.set('n', '<Space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  vim.keymap.set('n', '<Space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<Space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<Space>wl', function()
    P(vim.lsp.buf.list_workspace_folders())
  end, opts)
  -- See `:help vim.lsp.*` for documentation on functions

  -- Enable vim-illuminate
  require('illuminate').on_attach(client)
  vim.api.nvim_command([[ hi def link LspReferenceText CursorLine ]])
  vim.api.nvim_command([[ hi def link LspReferenceWrite CursorLine ]])
  vim.api.nvim_command([[ hi def link LspReferenceRead CursorLine ]])
  vim.keymap.set('x', ']r', 'm\'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
  vim.keymap.set('x', '[r', 'm\'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)
  vim.keymap.set('n', ']r', 'm\'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
  vim.keymap.set('n', '[r', 'm\'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)

  -- Setup lsp toggles
  require('plugins.lsp.utils').setup()

  -- Setup formatters and linters
  require('plugins.lsp.null-ls').setup()

  -- Setup UI configuration
  require('plugins.lsp.ui').setup()
end

local function select_default_formater(client)
  if client.name == 'null-ls' or not client.server_capabilities.document_formatting then
    return
  end
  Log:debug('Checking for formatter overriding for ' .. client.name)
  local formatters = require('plugins.lsp.null-ls.formatters')
  local client_filetypes = client.config.filetypes or {}
  for _, filetype in ipairs(client_filetypes) do
    if #vim.tbl_keys(formatters.list_registered(filetype)) > 0 then
      Log:info('Formatter overriding detected. Disabling formatting capabilities for ' .. client.name)
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
    end
  end
end

M.common_on_init = function(client, bufnr)
  select_default_formater(client)
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
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  return capabilities
end

function M.get_common_opts()
  return {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    -- on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
  }
end

M.make_config = function(server)
  local ok, config = pcall(require, 'plugins.lsp.lsp-configs.' .. server.name)
  if ok and config.lsp and config.lsp.setup then
    config = config.lsp.setup
    if not config.cmd then
      config.cmd = server._default_options.cmd
    end
    if not config.on_init then
      config.on_init = M.common_on_init
    end
    if not config.capabilities then
      config.capabilities = M.common_capabilities()
    end
  else
    config = server._default_options
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

  return config
end

-- lsp-install
M.setup_servers = function()
  require('nvim-lsp-installer').on_server_ready(function(server)
    local config = M.make_config(server)
    server:setup(config)
    vim.cmd([[ do User LspAttachBuffers ]])
  end)
end

function M.config()
  require('lspconfig')
  require('plugins.lsp.null-ls').config()
  M.setup_servers()
end

return M
