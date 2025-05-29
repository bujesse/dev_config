local Log = require('core.log')

M = {}

M.lsp_formatting = function(bufnr)
  local utils = require('core.utils')
  vim.lsp.buf.format({
    filter = function(client)
      local cwd = vim.fn.getcwd()
      local dir_name = vim.fn.fnamemodify(cwd, ':t')
      if string.find(cwd, 'pv_upload') then
        return utils.table_contains({ 'ruff' }, client.name)
      else
        return utils.table_contains({ 'null-ls', 'rust_analyzer' }, client.name)
      end
    end,
    bufnr = bufnr or vim.api.nvim_get_current_buf(),
    timeout_ms = 10000, -- Let null-ls decide on timeouts
  })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.common_on_attach(client, bufnr)
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
    '<cmd>lua vim.diagnostic.goto_prev({severity = { min = vim.diagnostic.severity.ERROR } })<CR>',
    opts
  )
  vim.keymap.set(
    'n',
    ']D',
    '<cmd>lua vim.diagnostic.goto_next({severity = { min = vim.diagnostic.severity.ERROR } })<CR>',
    opts
  )
  vim.keymap.set('n', '<Space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- Useful to add references to quickfix
  vim.keymap.set(
    'n',
    'gqd',
    '<cmd>lua vim.diagnostic.setqflist()<CR>',
    vim.tbl_deep_extend('force', opts, { desc = 'LSP Diagnostics to qf' })
  )
  vim.keymap.set(
    'n',
    'gqr',
    '<cmd>lua vim.lsp.buf.references()<CR>',
    vim.tbl_deep_extend('force', opts, { desc = 'LSP References to qf' })
  )

  -- if vim.bo.filetype == 'python' then
  -- Specific to darker only; it doesn't play nicely with null-ls
  -- vim.keymap.set('n', '<Leader>f', function()
  --   vim.cmd([[write!]])
  --   vim.cmd([[silent !darker --isort --skip-string-normalization -l 120 %]])
  --   -- ':silent w<cr> :silent !source ~/python_envs/nvim/bin/activate.fish && darker --isort --skip-string-normalization -l 120 %<Cr>',
  -- end, vim.tbl_deep_extend('force', opts, { desc = 'Format file', buffer = true }))
  -- else
  -- Use custom formatting
  if vim.bo.filetype == 'rust' then
    vim.keymap.set('n', '<Leader>f', '<cmd>RustFmt<CR>', { desc = 'Format file' })
    vim.api.nvim_command([[autocmd BufWritePre *.rs :RustFmt]])
  else
    -- Use lsp formatting
    vim.keymap.set('n', '<Leader>f', function()
      M.lsp_formatting()
    end, vim.tbl_deep_extend('force', opts, { desc = 'Format file' }))
  end

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
  if client:supports_method('textDocument/formatting') then
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

  -- Using blink.cmp instead of nvim-cmp
  -- local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  -- if not status_ok then
  --   return capabilities
  -- end
  -- capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
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
  require('mason-lspconfig').setup({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      local config = M.make_config(server_name)
      lspconfig[server_name].setup(config)
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    -- ['tsserver'] = function()
    --   require('typescript').setup({
    --     disable_commands = false, -- prevent the plugin from creating Vim commands
    --     go_to_source_definition = {
    --       fallback = true, -- fall back to standard LSP definition on failure
    --     },
    --     server = M.make_config(),
    --   })
    -- end,
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
    ['lua_ls'] = function()
      local config = M.make_config()
      config = vim.tbl_deep_extend('force', config, {
        settings = {
          Lua = {
            hint = {
              enable = true,
            },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })
      lspconfig.lua_ls.setup(config)
    end,
    ['ruff'] = function()
      local config = M.make_config()
      lspconfig.ruff.setup(config)
      M.config_client_specific_capabilities('lsp_attach_disable_ruff_hover', 'ruff', function(client)
        client.server_capabilities.hoverProvider = false
      end, 'LSP: Disable hover for Ruff')
    end,
    ['rust_analyzer'] = function()
      -- set up by rust-tools
    end,
    ['basedpyright'] = function()
      local config = M.make_config()
      config = vim.tbl_deep_extend('force', config, {
        settings = {
          basedpyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { '*' },
            },
          },
        },
      })
      lspconfig.basedpyright.setup(config)
    end,
  })
end

function M.config_client_specific_capabilities(augroup_name, client_name, callback, desc)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup(augroup_name, { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end
      if client.name == client_name then
        callback(client)
      end
    end,
    desc = desc,
  })
end

function M.config()
  M.first_setup = true
  M.diagnostics_visible = not GLOBAL_CONFIG.diagnostics_visible
  M.formatting_on = not GLOBAL_CONFIG.format_on_save

  require('lspconfig')
  require('plugins.lsp.null-ls').config()
  M.setup_servers()
  vim.cmd([[highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl guisp=Red]])
  vim.cmd([[highlight DiagnosticUnderlineWarn cterm=undercurl gui=undercurl guisp=Yellow]])
end

return M
