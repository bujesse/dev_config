return {
  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function(plugin)
      local components = require('plugins.lualine.components')
      return {
        options = {
          icons_enabled = true,
          theme = 'kanagawa',
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
            -- components.diagnostics,
            'filetype',
          },
          lualine_y = {
            'location',
          },
          lualine_z = {
            components.dap_status,
            components.treesitter_missing,
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
          'neo-tree',
          'quickfix',
          'nvim-dap-ui',
          'symbols-outline',
          'toggleterm',
        },
      }
    end,
  },
}
