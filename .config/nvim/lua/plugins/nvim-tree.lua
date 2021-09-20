local M = {}
local Log = require('core.log')

M.tree_width = 35

M.settings = {
  side = 'left',
  width = M.tree_width,
  show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
    tree_width = M.tree_width,
  },
  ignore = { '.git', 'node_modules', '.cache' },
  auto_open = 0,
  auto_close = 1,
  quit_on_open = 1,
  follow = 1,
  hide_dotfiles = 1,
  add_trailing = 1,
  group_empty = 1,
  git_hl = 1,
  root_folder_modifier = ':t',
  tab_open = 0,
  allow_resize = 1,
  lsp_diagnostics = 0,
  auto_ignore_ft = { 'startify', 'dashboard' },
  icons = {
    default = '',
    symlink = '',
    git = {
      unstaged = '',
      staged = 'S',
      unmerged = '',
      renamed = '➜',
      deleted = '',
      untracked = 'U',
      ignored = '◌',
    },
    folder = {
      default = '',
      open = '',
      empty = '',
      empty_open = '',
      symlink = '',
    },
  },
}

function M.config()
  local status_ok, nvim_tree_config = pcall(require, 'nvim-tree.config')
  if not status_ok then
    Log:error('Failed to load nvim-tree.config')
    return
  end

  local g = vim.g
  for opt, val in pairs(M.settings) do
    g['nvim_tree_' .. opt] = val
  end

  vim.g.nvim_tree_update_cwd = 1
  vim.g.nvim_tree_respect_buf_cwd = 1
  vim.g.nvim_tree_disable_netrw = 0
  vim.g.nvim_tree_hijack_netrw = 0
  vim.g.netrw_banner = 0

  local tree_cb = nvim_tree_config.nvim_tree_callback

  if not g.nvim_tree_bindings then
    g.nvim_tree_bindings = {
      { key = { '<CR>', 'o' }, cb = tree_cb('edit') },
      { key = 'h', cb = tree_cb('close_node') },
      { key = 'v', cb = tree_cb('vsplit') },
    }
  end

  local tree_view = require('nvim-tree.view')

  -- Add nvim_tree open callback
  local open = tree_view.open
  tree_view.open = function()
    M.on_open()
    open()
  end

  vim.api.nvim_set_keymap('n', '<Leader>n', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>N', '<cmd>NvimTreeFindFile<CR>', { noremap = true, silent = true })

  vim.cmd("au WinClosed * lua require('plugins.nvim-tree').on_close()")
end

function M.on_open()
  if package.loaded['bufferline.state'] then
    require('bufferline.state').set_offset(M.tree_width + 1, 'Explorer')
  end
end

function M.on_close()
  local buf = tonumber(vim.fn.expand('<abuf>'))
  local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
  if ft == 'NvimTree' and package.loaded['bufferline.state'] then
    require('bufferline.state').set_offset(0)
  end
end

function M.change_tree_dir(dir)
  local lib_status_ok, lib = pcall(require, 'nvim-tree.lib')
  if lib_status_ok then
    lib.change_dir(dir)
  end
end

return M
