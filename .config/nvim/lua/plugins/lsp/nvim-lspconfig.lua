local Log = require('core.log')

M = {}

M.lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == 'null-ls'
    end,
    bufnr = bufnr or vim.api.nvim_get_current_buf(),
  })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.common_on_attach(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = {
    noremap = true,
    silent = true,
    buffer = true,
  }

  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover()
  end, opts)
  vim.keymap.set('n', 'gK', function()
    require('core.utils').hover()
  end, vim.tbl_deep_extend('force', opts, { desc = 'Hover in new window' }))
  vim.keymap.set('n', '<C-_>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', 'gh', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.keymap.set(
    'n',
    '[D',
    '<cmd>lua vim.diagnostic.goto_prev({severity = { min = vim.diagnostic.severity.WARN } })<CR>',
    opts
  )
  vim.keymap.set(
    'n',
    ']D',
    '<cmd>lua vim.diagnostic.goto_next({severity = { min = vim.diagnostic.severity.WARN } })<CR>',
    opts
  )
  vim.keymap.set('n', '<Space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- Useful to add references to quickfix
  vim.keymap.set('n', 'gqd', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
  vim.keymap.set('n', 'gqr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  if vim.bo.filetype == 'python' then
    -- Specific to darker only; it doesn't play nicely with null-ls
    vim.keymap.set('n', '<Leader>f', function()
      vim.cmd([[write!]])
      vim.cmd([[silent !darker --isort --skip-string-normalization -l 120 %]])
      -- ':silent w<cr> :silent !source ~/python_envs/nvim/bin/activate.fish && darker --isort --skip-string-normalization -l 120 %<Cr>',
    end, vim.tbl_deep_extend('force', opts, { desc = 'Format file', buffer = true }))
  else
    vim.keymap.set('n', '<Leader>f', function()
      M.lsp_formatting()
    end, vim.tbl_deep_extend('force', opts, { desc = 'Format file' }))
    -- This doesn't work - it's supposed to format with '=' if there's no lsp formatter
    -- vim.keymap.set('n', '<Leader>f', function()
    --   local clients = vim.lsp.get_active_clients({ buffer = vim.api.nvim_buf_get_number(0) })
    --   if clients ~= nil then
    --     for _, c in ipairs(clients) do
    --       if c ~= nil and c.supports_method("textDocument/formatting") then
    --         P(c)
    --         vim.lsp.buf.format()
    --         return
    --       end
    --     end
    --   end
    --   vim.cmd([[norm! gg=G<C-o>]])
    -- end, opts)
  end

  -- Enable vim-illuminate
  require('illuminate').on_attach(client)
  vim.api.nvim_command([[ hi def link LspReferenceText CursorLine ]])
  vim.api.nvim_command([[ hi def link LspReferenceWrite CursorLine ]])
  vim.api.nvim_command([[ hi def link LspReferenceRead CursorLine ]])
  vim.keymap.set('x', ']r', 'm\'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
  vim.keymap.set('x', '[r', 'm\'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)
  vim.keymap.set('n', ']r', 'm\'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
  vim.keymap.set('n', '[r', 'm\'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)

  -- Enable lsp_signature.nvim
  require('lsp_signature').on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = 'rounded',
    },
    floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
    hint_enable = true, -- virtual hint enable
    hint_prefix = '',
    toggle_key = '<C-_>',
  }, bufnr)

  -- Setup UI configuration
  require('plugins.lsp.ui').setup()
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

  -- Diagnostic virutal text
  if M.first_setup then
    M.toggle_diagnostics(false)
  end

  -- Using lsp_lines.nvim
  -- vim.keymap.set('n', 'yod', function()
  --   M.toggle_diagnostics(true)
  -- end, { desc = 'Toggle Diagnostics', noremap = true, silent = true })

  -- Setup auto format on save
  if client.supports_method('textDocument/formatting') then
    local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = false })
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

    -- TODO: this will keep turning on af for newly mounted lsp's
    M.turn_autoformat_on(augroup, bufnr)

    vim.keymap.set('n', 'yoa', function()
      M.toggle_autoformat(augroup, bufnr, true)
    end, { desc = 'Toggle Autoformat', noremap = true, silent = true })
  end

  M.first_setup = false
end

function M.turn_autoformat_on(augroup, bufnr)
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    group = augroup,
    callback = function()
      M.lsp_formatting(bufnr)
      -- vim.lsp.buf.format({ bufnr = bufnr })
      -- M.async_formatting(bufnr)
    end,
  })
  M.formatting_on = true
end

-- autoformatting is a global setting
function M.toggle_autoformat(augroup, bufnr, should_log)
  M.formatting_on = not M.formatting_on

  if M.formatting_on then
    M.turn_autoformat_on(augroup, bufnr)
  else
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  end

  if should_log then
    print('Format on save ' .. (M.formatting_on and 'ON' or 'OFF'))
  end
end

function M.toggle_diagnostics(should_log)
  M.diagnostics_visible = not M.diagnostics_visible

  local conf = {
    virtual_text = M.diagnostics_visible,
    virtual_lines = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  }

  vim.diagnostic.config(conf)

  if should_log then
    print('Diagnostics are ' .. (M.diagnostics_visible and 'ON' or 'OFF'))
  end
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
M.async_formatting = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(bufnr, 'textDocument/formatting', vim.lsp.util.make_formatting_params({}), function(err, res, ctx)
    if err then
      local err_msg = type(err) == 'string' and err or err.message
      -- you can modify the log message / level (or ignore it completely)
      vim.notify('formatting: ' .. err_msg, vim.log.levels.WARN)
      return
    end

    -- don't apply results if buffer is unloaded or has been modified
    if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, 'modified') then
      return
    end

    if res then
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or 'utf-16')
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd('silent noautocmd update')
      end)
    end
  end)
end

function M.select_default_formater(client)
  if client.name == 'null-ls' or not client.server_capabilities.document_formatting then
    return
  end
  Log:debug('Checking for formatter overriding for ' .. client.name)
  local formatters = require('plugins.lsp.null-ls.formatters')
  local client_filetypes = client.config.filetypes or {}
  for _, filetype in ipairs(client_filetypes) do
    if #vim.tbl_keys(formatters.list_registered(filetype)) > 0 then
      P('Formatter overriding detected. Disabling formatting capabilities for ' .. client.name)
      client.server_capabilities.documentFormattingProvider = false
      -- client.server_capabilities.document_range_formatting = false
    end
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

  -- for nvim-ufo - lsp folding
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
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
    -- on_init = M.common_on_init,
    capabilities = M.common_capabilities(),
  }
end

function M.make_config(server_name)
  local config = {
    capabilities = M.common_capabilities(),
    on_attach = function(client, bufnr)
      M.common_on_attach(client, bufnr)
    end,
  }
  return config
end

-- mason-lspconfig
function M.setup_servers()
  local lspconfig = require('lspconfig')
  require('mason-lspconfig').setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      local config = M.make_config(server_name)
      lspconfig[server_name].setup(config)
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ['tsserver'] = function()
      require('typescript').setup({
        disable_commands = false, -- prevent the plugin from creating Vim commands
        go_to_source_definition = {
          fallback = true, -- fall back to standard LSP definition on failure
        },
        server = M.make_config(),
      })
    end,
    ['jsonls'] = function()
      local config = M.make_config()
      config = vim.tbl_deep_extend('force', config, {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      lspconfig.jsonls.setup(config)
    end,
  })
end

function M.config()
  M.first_setup = true
  M.diagnostics_visible = not GLOBAL_CONFIG.diagnostics_visible
  M.formatting_on = not GLOBAL_CONFIG.format_on_save

  require('lspconfig')
  require('plugins.lsp.null-ls').config()
  M.setup_servers()
end

return M
