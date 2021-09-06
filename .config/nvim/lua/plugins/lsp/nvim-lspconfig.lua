local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Enable vim-illuminate
  require 'illuminate'.on_attach(client)
  vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]

  -- Mappings.
  local opts = {
    noremap=true,
    silent=true,
  }

  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<Leader>af', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', ']r', 'm\'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
  buf_set_keymap('n', '[r', 'm\'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)
  -- See `:help vim.lsp.*` for documentation on functions

  -- Diagnostics

  vim.g.diagnostics_visible = true
  function _G.toggle_diagnostics(display_status)
    vim.g.diagnostics_visible = not vim.g.diagnostics_visible

    local conf = {
      virtual_text = vim.g.diagnostics_visible,
      signs = true,
      underline = true,
      update_in_insert = false,
    }

    -- toggle the diagnostic settings
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, conf)

    -- toggle the actual display of the diagnostics
    local clients = vim.lsp.get_active_clients()
    for client_id, _ in pairs(clients) do
      local buffers = vim.lsp.get_buffers_by_client_id(client_id)
      for _, buffer_id in ipairs(buffers) do
        vim.lsp.diagnostic.display(nil, buffer_id, client_id, conf)
      end
    end

    if display_status then
      print('Diagnostics are ' .. (vim.g.diagnostics_visible and 'on' or 'off'))
    end
  end

  -- Start with diagnostics off
  toggle_diagnostics(false)
  buf_set_keymap('n', 'yod', ':call v:lua.toggle_diagnostics(1)<CR>', opts)

  require("plugins.lsp.null-ls").setup(vim.bo.filetype)
end

-- config that activates keymaps and enables snippet support
local function make_config(server)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  }
end

-- lsp-install
local function setup_servers()
  require'lspinstall'.setup()

  -- get all installed servers
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    local config = make_config(server)
    require'lspconfig'[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
