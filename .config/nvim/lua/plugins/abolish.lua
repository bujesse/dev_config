-- Remap with which-key because I never remember these

vim.g.abolish_no_mappings = 1
require('which-key').register({
  name = '+abolish coerce word',
  s = { '<Plug>(abolish-coerce-word)s', 'snake_case' },
  m = { '<Plug>(abolish-coerce-word)m', 'MixedCase' },
  c = { '<Plug>(abolish-coerce-word)c', 'camelCase' },
  u = { '<Plug>(abolish-coerce-word)u', 'SNAKE_UPPERCASE' },
  d = { '<Plug>(abolish-coerce-word)d', 'dash-case (irreversible)' },
  t = { '<Plug>(abolish-coerce-word)t', 'Title Case (irreversible)' },
  ['<Space>'] = { '<Plug>(abolish-coerce-word)<Space>', 'Space Case (irreversible)' },
}, {
  prefix = 'cr',
})
