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
  buf_set_keymap('n', ']r', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
  buf_set_keymap('n', '[r', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)
  -- See `:help vim.lsp.*` for documentation on functions

  -- Diagnostics

  vim.g.diagnostics_visible = true

  local function turn_on_diagnostics()
    vim.g.diagnostics_visible = true
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
    }
    )
  end

  turn_on_diagnostics()

  function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
      vim.g.diagnostics_visible = false
      vim.lsp.diagnostic.clear(0)
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
      print('Diagnostics are hidden')
    else
      turn_on_diagnostics()
      print('Diagnostics are visible')
    end
  end

  buf_set_keymap('n', 'yod', ':call v:lua.toggle_diagnostics()<CR>', opts)
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
