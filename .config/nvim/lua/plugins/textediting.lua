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

  -- REPLACED WITH SUBSTITUTE.NVIM
  -- {
  --   'vim-scripts/ReplaceWithRegister',
  --   keys = {
  --     { 'R', '<Plug>ReplaceWithRegisterOperator' },
  --     { 'RR', '<Plug>ReplaceWithRegisterLine' },
  --     { 'R', '<Plug>ReplaceWithRegisterVisual', mode = 'v' },
  --   },
  -- },
  -- { 'tommcdo/vim-exchange' },

  {
    'gbprod/substitute.nvim',
    lazy = false,
    dependencies = { 'yanky.nvim' },
    keys = {
      { 'R', '<CMD>lua require("substitute").operator()<CR>' },
      { 'RR', '<CMD>lua require("substitute").line()<CR>' },
      -- { 'R$', '<CMD>lua require("substitute").eol()<CR>', mode = 'n' },
      { 'R', '<CMD>lua require("substitute").visual()<CR>', mode = 'x' },

      { 'cx', '<CMD>lua require("substitute.exchange").operator()<CR>' },
      { 'cxx', '<CMD>lua require("substitute.exchange").line()<CR>' },
      { 'X', '<CMD>lua require("substitute.exchange").visual()<CR>', mode = 'x' },
      { 'cxc', '<CMD>lua require("substitute.exchange").cancel()<CR>' },
    },
    config = function()
      require('substitute').setup({
        on_substitute = require('yanky.integration').substitute(),
        range = {
          prefix = 'R',
        },
      })
      vim.keymap.set('n', '<Leader>v', function()
        require('substitute').operator({
          count = 1,
          register = '0',
          motion = 'iw',
        })
      end)

      vim.api.nvim_set_hl(0, 'SubstituteExchange', { link = 'IncSearch' })
    end,
  },

  -- instant feedback on lsp rename
  {
    'smjonas/inc-rename.nvim',
    keys = {
      {
        'gR',
        function()
          return ':IncRename ' .. vim.fn.expand('<cword>')
        end,
        desc = 'Rename Symbol',
        expr = true,
      },
    },
    config = function()
      require('inc_rename').setup()
    end,
  },

  -- Text objects
  { 'michaeljsmith/vim-indent-object' },
  { 'dbakker/vim-paragraph-motion' },

  {
    'mg979/vim-visual-multi',
    -- https://github.com/mg979/vim-visual-multi/blob/b84a6d42c1c10678928b0bf8327f378c8bc8af5a/autoload/vm/plugs.vim
    lazy = false,
    keys = {
      { '<C-A-k>', '<Plug>(VM-Add-Cursor-Up)', desc = 'VM Add Cursor Up' },
      { '<C-A-j>', '<Plug>(VM-Add-Cursor-Down)', desc = 'VM Add Cursor Down' },
      { '<C-A-l>', '<Plug>(VM-Reselect-Last)', desc = 'VM Reselect' },
    },
    init = function()
      vim.g.VM_default_mappings = 0
    end,
  },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
      max_join_length = 1500,
    },
    keys = {
      { 'gs', ':lua require("treesj").toggle()<CR>', desc = 'Split/Join toggle' },
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
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' } },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' } },
      { ']p', '<Plug>(YankyPutIndentAfterLinewise)', mode = { 'n' } },
      { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', mode = { 'n' } },
      { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
      { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
      { '<A-p>', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
      { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
      { '[y', '<Plug>(YankyCycleForward)' },
      { ']y', '<Plug>(YankyCycleBackward)' },
      {
        '<Space>y',
        ':lua require("telescope").extensions.yank_history.yank_history({ sorting_strategy = "ascending", layout_strategy = "cursor", results_title = false, layout_config = { width = 0.8, height = 0.4, } })<cr>',
        desc = 'Yank History',
      },
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
          enabled = true,
        },
        picker = {
          telescope = {
            mappings = {
              default = mapping.set_register(utils.get_default_register()),
            },
          },
        },
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
      {
        '<Space>y',
        [[:lua require("telescope").extensions.neoclip.default({ sorting_strategy = "ascending", layout_strategy = "cursor", results_title = false, layout_config = { width = 0.8, height = 0.4, } })<CR>]],
      },
    },
  },

  -- search/replace in multiple files
  {
    'windwp/nvim-spectre',
    -- stylua: ignore
    keys = {
      { "<leader>rR", function() require("spectre").open({ is_insert_mode = true, })
      end, desc = "Replace in files (Spectre)" },
    },
  },

  -- Interactive Replacements
  {
    'AckslD/muren.nvim',
    opts = {
      patterns_width = 50,
      patterns_height = 20,
      options_width = 35,
      preview_height = 22,
      keys = {
        toggle_options_focus = '<C-e>',
      },
    },
    keys = {
      { '<leader>rr', ':MurenToggle<CR>', desc = 'Multi-interactive Replacements (Muren)' },
    },
  },
}
