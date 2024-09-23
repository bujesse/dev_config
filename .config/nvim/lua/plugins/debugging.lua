return {
  -- DAP
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      'mfussenegger/nvim-dap-python',
      {
        'leoluz/nvim-dap-go',
        dependencies = {
          'rcarriga/nvim-dap-ui',
        },
        opts = {},
        config = function(_, opts)
          require('dap-go').setup(opts)
          table.insert(require('dap').configurations.go, 1, {
            name = 'Delve Remote',
            type = 'go',
            request = 'attach',
            mode = 'remote',
            remotePath = '${workspaceFolder}',
            port = 2345,
            host = '127.0.0.1',
          })

          local augroup = vim.api.nvim_create_augroup('dap_ui', { clear = true })
          local dap, dapui = require('dap'), require('dapui')
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()

            -- Try to rerun if the termination was because of a save
            vim.api.nvim_create_autocmd('BufWritePost', {
              group = augroup,
              callback = function()
                vim.defer_fn(function()
                  if vim.tbl_isempty(require('dap').sessions()) then
                    local output = vim.fn.system('lsof -i -P -n | grep 2345')
                    if string.match(output, '2345') then
                      print('Debugger on port 2345 found. Restarting DAP...')
                      dap.run_last()
                    else
                      dapui.close()
                    end
                  end
                end, 3000)
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
        end,
      },
      {
        'ofirgall/goto-breakpoints.nvim',
        keys = {
          {
            ']B',
            function()
              require('goto-breakpoints').next()
            end,
            desc = 'Next Breakpoint',
          },
          {
            '[B',
            function()
              require('goto-breakpoints').prev()
            end,
            desc = 'Prev Breakpoint',
          },
        },
      },
    },
    keys = {
      { '<Space>db', "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = 'Toggle Breakpoint' },
      {
        '<Space>dB',
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
      { '<Space>dg', "<cmd>lua require'dap'.continue()<cr>", desc = 'DAP Go' },

      -- { '<Space>db', "<cmd>lua require'dap'.step_back()<cr>", desc = 'Step Back' },
      {
        '<Space>ds',
        "<cmd>lua require'dap'.disconnect({restart = true, terminateDebuggee = false})<cr>",
        desc = 'Disconnect',
      },
      {
        '<Space>dS',
        "<cmd>lua require'dap'.terminate()<cr>",
        desc = 'Stop Debuggee',
      },
      { '<Space>dP', "<cmd>lua require'dap'.pause()<cr>", desc = 'Pause' },
      { '<Space>dr', "<cmd>lua require'dap'.repl.toggle()<cr>", desc = 'Toggle Repl' },
      { '<Space>dq', "<cmd>lua require'dap'.close()<cr>", desc = 'Quit' },
      { '<Space>dd', "<cmd>lua require'dap'.run_last()<cr>", desc = 'DAP Last' },
      { '<Space>d-', "<cmd>lua require'dap'.clear_breakpoints()<cr>", desc = 'Clear Breakpoints' },
      { '<Space>du', "<cmd>lua require'dapui'.toggle({reset = true})<cr>", desc = 'Toggle UI' },
      { '<Space>dN', '<Cmd>lua require("dap-python").test_method()<Cr>', desc = 'Debug Nearest Test (dap-python)' },
      { '<Space>dc', '<Cmd>lua require("dap-python").test_class()<Cr>', desc = 'Debug Class (dap-python)' },
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

      require('dap-python').setup()
      require('dap-python').test_runner = 'pytest'
      require('dap-python').resolve_python = function()
        return '/home/bujesse/dev/execution/venv/bin/python'
      end

      local base_script_config = {
        type = 'python',
        python = '${workspaceFolder}/venv/bin/python',
        request = 'launch',
        name = 'Debug execution script',
        variablePresentation = {
          ['function'] = 'hide',
          special = 'hide',
          class = 'group',
          protected = 'group',
          -- "all": "inline",
        },
        program = '${workspaceFolder}/execution/scripts/run_with_app_context.py',
      }

      table.insert(require('dap').configurations.python, 1, {
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
        mode = 'remote',
        cwd = vim.fn.getcwd(),
        pathMappings = {
          {
            localRoot = vim.fn.getcwd(),
            remoteRoot = '/home/webapp/app',
          },
        },
        connect = {
          host = '127.0.0.1',
          port = 5678,
        },
      })
      table.insert(
        require('dap').configurations.python,
        2,
        vim.tbl_extend('force', base_script_config, {
          name = 'Debug create_txn_step_generation_migration',
          args = { 'create_txn_step_generation_migration' },
        })
      )
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
          size = 30,
        },
        {
          elements = {
            {
              id = 'watches',
              size = 0.5,
            },
            {
              id = 'repl',
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
                -- local output = vim.fn.system('lsof -i -P -n | grep 5678')
                local output = vim.fn.system('docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" -a')
                if string.match(output, '5678') then
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

  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {
      clear_on_continue = true,
      only_first_definition = false,
    },
    keys = {
      {
        'yov',
        '<cmd>DapVirtualTextToggle<CR>',
        desc = 'Toggle DAP Virtual Text',
      },
      {
        'yov',
        '<cmd>DapVirtualTextForceRefresh<CR>',
        desc = 'Toggle DAP Virtual Text',
      },
    },
  },

  -- easy print statement insertions
  {
    'andrewferrier/debugprint.nvim',
    opts = {
      create_keymaps = false,
      move_to_debugline = true,
    },
    keys = {
      -- {
      --   '<Space>dp',
      --   function()
      --     return require('debugprint').debugprint()
      --   end,
      --   expr = true,
      --   desc = 'Debug print string',
      -- },
      {
        '<Space>dp',
        function()
          return require('debugprint').debugprint({ variable = true })
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Debug print variable',
      },
      {
        '<Space>d-',
        ':DeleteDebugPrints<CR>',
        desc = 'Delete debug prints',
      },
    },
  },
}
