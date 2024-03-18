return {
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = true,
          autohide = true,
          jump_labels = true,
          multi_line = true,
          -- by default all keymaps are enabled, but you can disable some of them,
          -- by removing them from the list.
          keys = { 'f', 'F', 't', 'T', ';' },
          highlight = { backdrop = false },
        },
        search = {
          enabled = false, -- enable flash for search
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
          search = {
            -- `forward` will be automatically set to the search direction
            -- `mode` is always set to `search`
            -- `incremental` is set to `true` when `incsearch` is enabled
          },
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o' },
        function()
          -- show labeled treesitter nodes around the cursor
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          -- jump to a remote location to execute the operator
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        '<C-R>',
        mode = { 'n', 'o', 'x' },
        function()
          -- show labeled treesitter nodes around the search matches
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
    },
  },
}
