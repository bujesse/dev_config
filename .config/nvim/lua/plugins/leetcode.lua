return {
  {
    'kawre/leetcode.nvim',
    cmd = 'Leet',
    build = ':TSUpdate html',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      arg = 'leetcode.nvim',

      lang = 'python3',

      storage = {
        home = vim.fn.stdpath('data') .. '/leetcode',
        cache = vim.fn.stdpath('cache') .. '/leetcode',
      },

      plugins = {
        non_standalone = true,
      },

      logging = true,

      injector = {},

      cache = {
        update_interval = 60 * 60 * 24 * 7,
      },

      console = {
        open_on_runcode = true,

        dir = 'row',

        size = {
          width = '90%',
          height = '75%',
        },

        result = {
          size = '60%',
        },

        testcase = {
          virt_text = true,

          size = '40%',
        },
      },

      description = {
        position = 'left',

        width = '40%',

        show_stats = true,
      },

      picker = { provider = nil },

      hooks = {
        ['enter'] = {
          function()
            vim.cmd([[Copilot disable]])
            vim.keymap.set('n', '<Space><CR>', '<CMD>Leet run<CR>', { buffer = true })
          end,
        },

        ['question_enter'] = {
          function()
            vim.cmd([[LspStop]])
          end,
        },

        ['leave'] = {
          function()
            vim.cmd([[Copilot enable]])
            vim.cmd([[LspStart]])
          end,
        },
      },

      keys = {
        toggle = { 'q' },
        confirm = { '<CR>' },

        reset_testcases = 'r',
        use_testcase = 'U',
        focus_testcases = 'H',
        focus_result = 'L',
      },

      theme = {},

      image_support = false,
    },
  },
}
