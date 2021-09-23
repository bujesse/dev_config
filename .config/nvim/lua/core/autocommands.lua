local M = {}

M.autocommands = {
  _general_settings = {
    {
      -- Load lua files in ftplugin
      'Filetype',
      '*',
      'lua require(\'core.ft\').do_filetype(vim.fn.expand("<amatch>"))',
    },
    {
      'TextYankPost',
      '*',
      "lua require('vim.highlight').on_yank({higroup = 'IncSearch', timeout = 300})",
    },
    {
      'FileType',
      'qf',
      'set nobuflisted',
    },
    {
      'BufWritePre',
      '*',
      ':call TrimWhitespace()',
    },
    {
      'BufEnter,BufWinEnter,FileType,WinEnter',
      '*',
      'lua require("core.utils").hide_statusline()',
    },
    -- { "BufWritePost", config.path, "lua require('utils').reload_lv_config()" },
  },
  _markdown = {
    { 'FileType', 'markdown', 'setlocal wrap' },
    { 'FileType', 'markdown', 'setlocal spell' },
  },
  _buffer_bindings = {
    { 'FileType', 'floaterm', 'nnoremap <silent> <buffer> q :q<CR>' },
  },
  _auto_resize = {
    -- will cause split windows to be resized evenly if main window is resized
    { 'VimResized', '*', 'wincmd =' },
  },
  _general_lsp = {
    { 'FileType', 'lspinfo', 'nnoremap <silent> <buffer> q :q<CR>' },
  },
  _help = {
    -- Open split vertically on the right
    { 'BufEnter', '*.txt', "if &buftype == 'help' | wincmd L | endif" },
  },
  custom_groups = {},
}

function M.define_augroups(definitions) -- {{{1
  -- Create autocommand groups based on the passed definitions
  --
  -- The key will be the name of the group, and each definition
  -- within the group should have:
  --    1. Trigger
  --    2. Pattern
  --    3. Text
  -- just like how they would normally be defined from Vim itself
  for group_name, definition in pairs(definitions) do
    vim.cmd('augroup ' .. group_name)
    vim.cmd('autocmd!')

    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
      vim.cmd(command)
    end

    vim.cmd('augroup END')
  end
end

M.config = function()
  M.define_augroups(M.autocommands)
end

return M
