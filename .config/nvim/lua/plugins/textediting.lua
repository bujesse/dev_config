-- Text editing
return {

  {
    -- cr_ to change between cases
    'tpope/vim-abolish',
    keys = {
      { 'crs', '<Plug>(abolish-coerce-word)s', desc = 'snake_case', mode = { 'n', 'x' } },
      { 'crm', '<Plug>(abolish-coerce-word)m', desc = 'MixedCase', mode = { 'n', 'x' } },
      { 'crc', '<Plug>(abolish-coerce-word)c', desc = 'camelCase', mode = { 'n', 'x' } },
      { 'cru', '<Plug>(abolish-coerce-word)u', desc = 'SNAKE_UPPERCASE', mode = { 'n', 'x' } },
      { 'crd', '<Plug>(abolish-coerce-word)d', desc = 'dash-case (irreversible)', mode = { 'n', 'x' } },
      { 'crt', '<Plug>(abolish-coerce-word)t', desc = 'Title Case (irreversible)', mode = { 'n', 'x' } },
      { 'cr<Space>', '<Plug>(abolish-coerce-word)<Space>', desc = 'Space Case (irreversible)', mode = { 'n', 'x' } },
    },
    config = function()
      -- Remap with which-key because I never remember these
      vim.g.abolish_no_mappings = 1
    end,
  },

  {
    'vim-scripts/ReplaceWithRegister',
    keys = {
      { 'R', '<Plug>ReplaceWithRegisterOperator' },
      { 'RR', '<Plug>ReplaceWithRegisterLine' },
      { 'R', '<Plug>ReplaceWithRegisterVisual', mode = 'v' },
    },
  },

  -- instant feedback on lsp rename
  {
    'smjonas/inc-rename.nvim',
    keys = {
      { 'gR', function() return ":IncRename " .. vim.fn.expand("<cword>") end, expr = true },
    },
    config = function()
      require("inc_rename").setup()
    end
  },

  -- Text objects
  { 'michaeljsmith/vim-indent-object' },
  { 'dbakker/vim-paragraph-motion' },

  { 'tommcdo/vim-exchange' },

  { 'mg979/vim-visual-multi' },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
    keys = {
      { 'gs', ':TSJToggle<cr>' },
    },
  },

  {
    'haya14busa/vim-asterisk',
    keys = {
      { '*', '<Plug>(asterisk-*)', mode = { 'n', 'x' } },
      { '#', '<Plug>(asterisk-#)', mode = { 'n', 'x' } },
      { 'g*', '<Plug>(asterisk-g*)', mode = { 'n', 'x' } },
      { 'g#', '<Plug>(asterisk-g#)', mode = { 'n', 'x' } },
      { 'z*', '<Plug>(asterisk-z*)', mode = { 'n', 'x' } },
      { 'gz*', '<Plug>(asterisk-gz*)', mode = { 'n', 'x' } },
      { 'z#', '<Plug>(asterisk-z#)', mode = { 'n', 'x' } },
      { 'gz#', '<Plug>(asterisk-gz#)', mode = { 'n', 'x' } },
      { 'gz#', '<Plug>(asterisk-gz#)', mode = { 'n', 'x' } },
    },
    init = function()
      vim.g['asterisk#keeppos'] = 1
    end,
  },

  -- better yank management
  {
    'gbprod/yanky.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' } },
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' } },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' } },
      { ']p', '<Plug>(YankyPutIndentAfterLinewise)', mode = { 'n', 'x' } },
      { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', mode = { 'n', 'x' } },
      { '[y', '<Plug>(YankyCycleForward)' },
      { ']y', '<Plug>(YankyCycleBackward)' },
      { '<Space>y',
        ':lua require("telescope").extensions.yank_history.yank_history({ sorting_strategy = "ascending", layout_strategy = "cursor", results_title = false, layout_config = { width = 0.8, height = 0.4, } })<cr>' },
    },
    opts = function()
      local utils = require('yanky.utils')
      local mapping = require('yanky.telescope.mapping')
      return {
        highlight = {
          on_put = false,
          on_yank = false,
          timer = 300,
        },
        system_clipboard = {
          sync_with_ring = false,
        },
        preserve_cursor_position = {
          enabled = true
        },
        picker = {
          telescope = {
            mappings = {
              default = mapping.set_register(utils.get_default_register()),
            }
          }
        }
      }
    end,
  },


  -- search macros
  {
    'AckslD/nvim-neoclip.lua',
    enabled = false,
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'kkharji/sqlite.lua',
    },
    keys = {
      { '<Space>y',
        [[:lua require("telescope").extensions.neoclip.default({ sorting_strategy = "ascending", layout_strategy = "cursor", results_title = false, layout_config = { width = 0.8, height = 0.4, } })<CR>]] }
    },
  },

}