return {
  -- DAP
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      'mason-nvim-dap.nvim',
      'mfussenegger/nvim-dap-python',
      {
        'ofirgall/goto-breakpoints.nvim',
        keys = {
          {
            ']b',
            function()
              require('goto-breakpoints').next()
            end,
            desc = 'Next Breakpoint',
          },
          {
            '[b',
            function()
              require('goto-breakpoints').prev()
            end,
            desc = 'Prev Breakpoint',
          },
        },
      },
    },
    keys = {
      { '<Space>b', "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = 'Toggle Breakpoint' },
      {
        '<Space>B',
        "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
        desc = 'Toggle Breakpoint',
      },
      {
        '<Space>dL',
        "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
        desc = 'Toggle Breakpoint',
      },

      { '<F5>', "<cmd>lua require'dap'.step_into()<cr>", desc = 'Step Into' },
      { '<F4>', "<cmd>lua require'dap'.step_over()<cr>", desc = 'Step Over' },
      { '<F3>', "<cmd>lua require'dap'.step_out()<cr>", desc = 'Step Out' },
      { '<F2>', "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = 'Run To Cursor' },
      { '<F1>', "<cmd>lua require'dap'.continue()<cr>", desc = 'Continue' },

      { '<Space>db', "<cmd>lua require'dap'.step_back()<cr>", desc = 'Step Back' },
      {
        '<Space>ds',
        "<cmd>lua require'dap'.disconnect({restart = true, terminateDebuggee = false})<cr>",
        desc = 'Disconnect',
      },
      { '<Space>dp', "<cmd>lua require'dap'.pause()<cr>", desc = 'Pause' },
      { '<Space>dr', "<cmd>lua require'dap'.repl.toggle()<cr>", desc = 'Toggle Repl' },
      { '<Space>dq', "<cmd>lua require'dap'.close()<cr>", desc = 'Quit' },
      { '<Space>dd', "<cmd>lua require'dap'.run_last()<cr>", desc = 'DAP Last' },
      { '<Space>d-', "<cmd>lua require'dap'.clear_breakpoints<cr>", desc = 'Clear Breakpoints' },
      { '<Space>du', "<cmd>lua require'dapui'.toggle({reset = true})<cr>", desc = 'Toggle UI' },
    },
    config = function(_, opts)
      vim.fn.sign_define('DapBreakpoint', {
        text = 'B',
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = '',
      })
      -- vim.fn.sign_define('DapBreakpointRejected', lvim.builtin.dap.breakpoint_rejected)
      vim.fn.sign_define('DapStopped', {
        text = '>',
        texthl = 'DiagnosticSignWarn',
        linehl = 'Visual',
        numhl = 'DiagnosticSignWarn',
      })

      local dap = require('dap')
      require('mason-nvim-dap').setup({
        ensure_installed = { 'python' },
        handlers = {
          function(config)
            -- all sources with no handler get passed here
            -- Keep original functionality of `automatic_setup = true`
            require('mason-nvim-dap').default_setup(config)
          end,
          python = function(config)
            require('dap-python').setup(vim.g.python3_host_prog)
            require('dap-python').test_runner = 'pytest'
            table.insert(dap.configurations.python, 1, {
              type = 'python',
              request = 'attach',
              name = 'Debugpy',
              justMyCode = false,
              -- subProcess = true,
              redirectOutput = true,
              variablePresentation = {
                ['function'] = 'hide',
                special = 'hide',
                class = 'group',
                protected = 'group',
                -- "all": "inline",
              },
              connect = {
                host = '127.0.0.1',
                port = 5678,
              },
            })
            --[[ 
            This seems to work. Key takeaways:
            - Flask spawns 2 processes when it's hot-reloading because one of them is a file watcher. The debugger seems to attach to the wrong process in this case.
            - variablePresentation is very helpful to hide fluff
            - one could set up their own watcher using inotifywait tools, and just do attaches
          ]]
            table.insert(dap.configurations.python, 2, {
              type = 'python',
              request = 'launch',
              name = 'Launch Execution',
              -- program = 'app.py',
              -- stopOnEntry = true,
              justMyCode = false,
              variablePresentation = {
                ['function'] = 'hide',
                special = 'hide',
                class = 'group',
                protected = 'group',
                -- "all": "inline",
              },
              -- subProcess = true,
              module = 'flask',
              args = { 'run', '--host=0.0.0.0', '--port=5010', '--without-threads', '--no-reload' },
              -- cwd = '${workspaceFolder}',
              -- python = '${workspaceFolder}/venv/bin/python',
              -- pathMappings = {
              --   {
              --     localRoot = '${workspaceFolder}',
              --     remoteRoot = '${workspaceFolder}',
              --   },
              -- },
              -- env = {
              --   FLASK_ENV = 'development',
              --   FLASK_DEBUG = 1,
              --   FLASK_APP = 'execution:create_app()',
              -- },
            })
            -- FIXME: This line is needed for neotest debugging to work, but makes regular debugging not work
            -- require('mason-nvim-dap').default_setup(config)
          end,
        },
      })
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    opts = {
      controls = {
        enabled = false,
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = '+',
        current_frame = '>',
        expanded = '-',
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.70,
            },
            {
              id = 'breakpoints',
              size = 0.15,
            },
            {
              id = 'stacks',
              size = 0.15,
            },
          },
          position = 'left',
          size = 40,
        },
        {
          elements = {
            {
              id = 'repl',
              size = 0.5,
            },
            {
              id = 'watches',
              size = 0.5,
            },
          },
          position = 'bottom',
          size = 10,
        },
      },
      mappings = {
        edit = 'e',
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        repl = 'r',
        toggle = 't',
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
    config = function(_, opts)
      local augroup = vim.api.nvim_create_augroup('dap_ui', { clear = true })
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup(opts)

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()

        -- Try to rerun if the termination was because of a save
        vim.api.nvim_create_autocmd('BufWritePost', {
          group = augroup,
          callback = function()
            vim.defer_fn(function()
              if vim.tbl_isempty(require('dap').sessions()) then
                local lsof_output = vim.fn.system('lsof -i -P -n | grep 5678')
                if string.match(lsof_output, '5678') then
                  -- print('Debugger on port 5678 found. Restarting DAP...')
                  dap.run_last()
                else
                  dapui.close()
                end
              end
            end, 1000)
          end,
        })
      end
      dap.listeners.after.event_terminated['dapui_config'] = function(session, body)
        vim.defer_fn(function()
          if vim.tbl_isempty(require('dap').sessions()) then
            dapui.close()
            vim.api.nvim_clear_autocmds({ group = augroup })
          end
        end, 2000)
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      vim.keymap.set('n', '<Space>de', ':lua require("dapui").eval()<CR>', { desc = 'DapUI Eval' })
      vim.keymap.set('n', '<Space>da', ':lua require("dapui").elements.watches.add()<CR>', { desc = 'Add to watches' })
      vim.keymap.set('x', '<Space>da', function()
        local visual_selection = require('core.utils').selected_text()
        require('dapui').elements.watches.add(visual_selection)
      end, { desc = 'Add to watches' })
    end,
  },

  -- easy print statement insertions
  {
    'andrewferrier/debugprint.nvim',
    opts = {
      create_keymaps = false,
      move_to_debugline = true,
    },
    keys = {
      {
        '<Leader>dp',
        function()
          return require('debugprint').debugprint()
        end,
        expr = true,
        desc = 'Debug print string',
      },
      {
        '<Leader>dd',
        function()
          return require('debugprint').debugprint({ variable = true })
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Debug print variable',
      },
      {
        '<Leader>d',
        function()
          return require('debugprint').debugprint({ motion = true })
        end,
        expr = true,
        desc = 'Debug print motion',
      },
      {
        '<Leader>d-',
        ':DeleteDebugPrints<CR>',
        desc = 'Delete debug prints',
      },
    },
  },
}
