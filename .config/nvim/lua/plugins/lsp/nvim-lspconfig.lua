local Log = require('core.log')

M = {}

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
  }

  vim.keymap.set('n', 'gq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
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

  if vim.bo.filetype == 'python' then
    -- Specific to darker only; it doesn't play nicely with null-ls
    vim.keymap.set(
      'n',
      '<Leader>f',
      function()
        vim.cmd.write()
        vim.cmd([[silent !darker --isort --skip-string-normalization -l 120 %]])

        -- VAGRANT
        vim.defer_fn(function()
          vim.cmd('checktime')
        end, 1500)
        -- ':silent w<cr> :silent !source ~/python_envs/nvim/bin/activate.fish && darker --isort --skip-string-normalization -l 120 %<Cr>',
      end,
      { buffer = true }
    )
  else
    vim.keymap.set('n', '<Leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
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

  -- Setup formatters and linters
  require('plugins.lsp.null-ls').setup()
  M.select_default_formater(client)

  -- Setup UI configuration
  require('plugins.lsp.ui').setup()

  -- Diagnostic virutal text
  if M.first_setup then
    M.toggle_diagnostics(false)
  end

  vim.keymap.set('n', 'yod', function()
    M.toggle_diagnostics(true)
  end, { noremap = true, silent = true })

  -- Setup auto format on save
  if client.supports_method('textDocument/formatting') then
    local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = false })
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

    -- TODO: this will keep turning on af for newly mounted lsp's
    M.turn_autoformat_on(augroup, bufnr)

    vim.keymap.set('n', 'yoa', function()
      M.toggle_autoformat(augroup, bufnr, true)
    end, { noremap = true, silent = true })
  end

  M.first_setup = false
end

function M.turn_autoformat_on(augroup, bufnr)
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    group = augroup,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr })
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

  vim.lsp.buf_request(bufnr, 'textDocument/formatting', vim.lsp.util.make_formatting_params({}),
    function(err, res, ctx)
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

M.common_on_init = function(client, bufnr)
  M.select_default_formater(client)
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
    -- on_init = M.common_on_init,
    capabilities = M.common_capabilities(),
  }
end

function M.make_config(server_name)
  local ok, config = pcall(require, 'plugins.lsp.lsp-configs.' .. server_name)
  if ok and config.lsp and config.lsp.setup then
    config = config.lsp.setup
    if not config.capabilities then
      config.capabilities = M.common_capabilities()
    end
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

  return config
end

-- lsp-install
function M.setup_servers()
  require('mason-lspconfig').setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      local config = M.make_config(server_name)
      require('lspconfig')[server_name].setup(config)
      -- vim.cmd([[ do User LspAttach ]])
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    -- ['pyright'] = function()
    --   P('Hello')
    -- end,
  })
end

function M.config()
  M.first_setup = true
  M.diagnostics_visible = not GLOBAL_CONFIG.diagnostics_visible
  M.formatting_on = not GLOBAL_CONFIG.format_on_save


  -- This must run first
  require('neodev').setup({
    -- library = {
    --   -- buildtime = false,
    --   -- types = false,
    plugins = { 'plenary.nvim', 'telescope.nvim' }, -- this one makes it slow; probably because i have too many i guess. Can use a table here if i want access to certain plugins. In fact it's probably just a few bad plugins making it slow
    -- },
  })
  require('lspconfig')
  require('plugins.lsp.null-ls').config()
  M.setup_servers()
end

return M
