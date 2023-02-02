local M = {}

M.autocommands = {
  _general_settings = {
    {
      -- Load lua files in ftplugin
      event = 'Filetype',
      opts = { pattern = '*', command = 'lua require(\'core.ft\').do_filetype(vim.fn.expand("<amatch>"))', }
    },
    { event = 'TextYankPost',
      opts = { pattern = '*', command = "lua require('vim.highlight').on_yank({higroup = 'IncSearch', timeout = 300})" } },
    { event = 'FileType', opts = { pattern = 'qf', command = 'set nobuflisted' } },
    -- {
    --   'BufWritePre',
    --   '*',
    --   ':call TrimWhitespace()',
    -- },
  },
  _markdown = {
    {
      event = 'FileType',
      opts = { pattern = 'markdown', command = 'setlocal wrap' },
    },
    {
      event = 'FileType',
      opts = { pattern = 'markdown', command = 'setlocal spell' },
    },
  },
  _auto_resize = {
    -- will cause split windows to be resized evenly if main window is resized
    { event = 'VimResized', opts = { pattern = '*', command = 'wincmd =' } },
  },
  _general_lsp = {
    { event = 'FileType', opts = { pattern = 'lspinfo', command = 'nnoremap <silent> <buffer> q :q<CR>' } },
  },
  _vagrant = {
    {
      event = 'BufWritePost',
      opts = {
        pattern = '*',
        callback = function() vim.defer_fn(function() vim.cmd('checktime') end, 1500) end,
      },
    },
  },
}

---Simple way to bulk define augroup/commands
---@param definitions table<string, table<string, any>>
function M.define_augroups(definitions)
  for group_name, commands in pairs(definitions) do
    for _, command in ipairs(commands) do
      local augroup = vim.api.nvim_create_augroup(group_name, { clear = true })
      vim.tbl_deep_extend('force', command.opts, { group = augroup })
      vim.api.nvim_create_autocmd(command.event, command.opts)
    end
  end
end

function M.config()
  M.define_augroups(M.autocommands)
end

return M
