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
})

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.tsx.used_by = { 'javascript', 'typescript.tsx' }
