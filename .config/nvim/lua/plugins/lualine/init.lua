local M = {}

M.config = function()
  local components = require('plugins.lualine.components')

  require('lualine').setup({
    options = {
      icons_enabled = true,
      theme = 'gruvbox',
      component_separators = {
        left = '',
        right = '',
      },
      section_separators = {
        left = '',
        right = '',
      },
      disabled_filetypes = {},
    },
    sections = {
      lualine_a = { components.mode },
      lualine_b = {
        components.branch,
        components.diff,
      },
      lualine_c = {
        {
          'filename',
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
        },
      },
      lualine_x = {
        components.diagnostics,
        'filetype',
      },
      lualine_y = {
        'progress',
      },
      lualine_z = {
        components.treesitter,
        components.lsp,
        components.python_env,
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {
      'nvim-tree',
      'quickfix',
    },
  })
end

return M
