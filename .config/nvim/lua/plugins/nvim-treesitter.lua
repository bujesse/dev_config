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
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',

          -- Or you can define your own textobjects like this
          ['iF'] = {
            python = '(function_definition) @function',
            cpp = '(function_definition) @function',
            c = '(function_definition) @function',
            java = '(method_declaration) @function',
          },
        },
      },
    },
  })

  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.tsx.used_by = { 'javascript', 'typescript.tsx' }
end

return M
