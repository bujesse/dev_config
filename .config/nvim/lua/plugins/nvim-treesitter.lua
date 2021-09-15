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
    --       ['],'] = '@parameter.inner',
    --     },
    --     swap_previous = {
    --       ['[,'] = '@parameter.inner',
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

    --       ['a,'] = '@parameter.outer',
    --       ['i,'] = '@parameter.inner',
    --     },
    --   },
    --   move = {
    --     enable = true,
    --     set_jumps = true, -- whether to set jumps in the jumplist
    --     goto_next_start = {
    --       [']f'] = '@function.outer',
    --       [']c'] = '@class.outer',
    --     },
    --     goto_next_end = {
    --       [']F'] = '@function.outer',
    --       [']C'] = '@class.outer',
    --     },
    --     goto_previous_start = {
    --       ['[f'] = '@function.outer',
    --       ['[c'] = '@class.outer',
    --     },
    --     goto_previous_end = {
    --       ['[F'] = '@function.outer',
    --       ['[C'] = '@class.outer',
    --     },
    --   },
    -- },
  })

--   local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
--   parser_config.tsx.used_by = { 'javascript', 'typescript.tsx' }
end

return M
