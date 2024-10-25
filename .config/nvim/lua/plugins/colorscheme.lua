return {
  {
    'rebelot/kanagawa.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    enabled = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      undercurl = true,
      compile = true,
      colors = {
        theme = {
          wave = {
            ui = {
              bg_gutter = 'none',
              float = {
                bg_border = 'none',
              },
            },
          },
        },
      },
      overrides = function(colors) -- add/modify highlights
        return {
          CursorLine = { bg = '#504945' },
        }
      end,
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      vim.cmd([[colorscheme kanagawa]])
    end,
  },

  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    enabled = false,
    priority = 1000,
    opt = {
      undercurl = true,
      underline = true,
      bold = true,
      italic = true,
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = 'soft', -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        CursorLine = { bg = '#504945' }, -- make CursorLine visible af
      },
      dim_inactive = false,
      transparent_mode = false,
    },
    config = function()
      vim.o.background = 'dark' -- or "light" for light mode
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
}
