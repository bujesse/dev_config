local M = {}

M.config = function()
  require('nvim-treesitter.configs').setup({
    highlight = {
      enable = true,
      disable = {},
    },
    indent = {
      enable = false,
      disable = {},
    },
    ensure_installed = {
      'python',
      'bash',
      'lua',
      'vim',
      'tsx',
      'json',
      'yaml',
      'html',
      'scss',

      'javascript',
      'typescript',
      'vue',
    },
    -- textobjects = {
    --   swap = {
    --     enable = true,
    --     swap_next = {
    --       ['<leader>a'] = '@parameter.inner',
    --     },
    --     swap_previous = {
    --       ['<leader>A'] = '@parameter.inner',
    --     },
    --   },
    --   select = {
    --     enable = true,

    --     -- Automatically jump forward to textobj, similar to targets.vim
    --     lookahead = true,

    --     keymaps = {
    --       -- You can use the capture groups defined in textobjects.scm
    --       ['af'] = '@function.outer',
    --       ['if'] = '@function.inner',
    --       ['ac'] = '@class.outer',
    --       ['ic'] = '@class.inner',

    --       ['i,'] = '@parameter.outer',
    --       ['a,'] = '@parameter.inner',
    --     },
    --   },
    -- },
  })

  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.tsx.used_by = { 'javascript', 'typescript.tsx' }
end

return M
