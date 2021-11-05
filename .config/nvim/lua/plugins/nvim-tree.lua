local M = {}

M.tree_width = 35

M.settings = {
  show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
    tree_width = M.tree_width,
  },
  quit_on_open = 1,
  respect_buf_cwd = 1,
  netrw_banner = 0,
  add_trailing = 1,
  group_empty = 1,
  git_hl = 1,
  root_folder_modifier = ':t',
  allow_resize = 1,
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
  local g = vim.g
  for opt, val in pairs(M.settings) do
    g['nvim_tree_' .. opt] = val
  end

  require('nvim-tree').setup({
    disable_netrw = false,
    hijack_netrw = false,
    auto_close = false,
    hijack_cursor = true,
    update_cwd = true,
    open_on_tab = 0,
    ignore_ft_on_setup = { 'startify', 'dashboard' },
    -- follow = 1,
    view = {
      side = 'left',
      width = M.tree_width,
      mappings = {
        custom_only = false,
        list = {
          { key = 'v', cb = 'vsplit' },
        },
      },
    },
    diagnostics = {
      enable = false,
      icons = { hint = '', info = '', warning = '', error = '' },
    },
    update_to_buf_dir = {
      enable = false,
      auto_open = false,
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = { 'startify' },
    },
    filters = {
      custom = { '.git', 'node_modules', '.cache' },
    },
  })

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
    require('bufferline.state').set_offset(M.tree_width + 1, 'File Explorer')
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
