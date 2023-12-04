function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', [[<C-\>]], [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-q>', [[<Cmd>wincmd q<CR>]], opts)
  vim.keymap.set('t', '<C-\\><C-\\>', [[<Cmd>wincmd q<CR>]], opts)
end

return {
  -- terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup({
        shell = '/usr/bin/fish',
        open_mapping = [[<leader>tt]],
        insert_mappings = false,
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        terminal_mappings = false,
        close_on_exit = false,
      })

      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({
        cmd = 'lazygit',
        dir = 'git_dir',
        hidden = true,
        direction = 'float',
        float_opts = {
          border = 'double',
        },
        env = {
          -- pip install neovim-remote
          GIT_EDITOR = [[nvr -cc vsplit --remote-wait +'set bufhidden=wipe']],
        },
        on_open = function(term)
          vim.cmd('startinsert!')
          vim.keymap.set('t', ',l', [[<Cmd>wincmd q<CR>]], { buffer = term.bufnr })
        end,
        on_close = function(term) end,
        count = 99,
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      function _helix_toggle()
        local filename = vim.api.nvim_buf_get_name(0)
        local line, column = unpack(vim.api.nvim_win_get_cursor(0))
        local helix = Terminal:new({
          cmd = 'hx ' .. filename .. ':' .. line .. ':' .. column,
          dir = 'git_dir',
          hidden = true,
          direction = 'float',
          float_opts = {
            border = 'double',
          },
          count = 98,
          on_close = function(_)
            -- reload the file to apply any edits from hx
            vim.cmd('checktime')
          end,
        })
        helix:toggle()
      end

      local vertical = Terminal:new({
        cmd = 'fish',
        dir = 'git_dir',
        hidden = true,
        direction = 'vertical',
        count = 97,
      })

      function _vertical_toggle()
        vertical:toggle()
      end

      vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap(
        'n',
        '<leader>h',
        '<cmd>lua _helix_toggle()<CR>',
        { desc = 'Helix editor', noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>tv',
        '<cmd>lua _vertical_toggle()<CR>',
        { desc = 'Vertical terminal', noremap = true, silent = true }
      )

      vim.api.nvim_create_user_command('ToggleTermCurrentDir', function()
        local buf_dir = require('core.utils').get_buffer_dir()
        Terminal:new({
          dir = buf_dir,
          on_open = function(term)
            vim.cmd('startinsert!')
          end,
        }):toggle()
      end, {})

      -- only want these mappings for toggle term
      vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
    end,
  },

  -- Open files from term in current nvim instance
  {
    'willothy/flatten.nvim',
    lazy = false,
    priority = 1001,
    opts = {
      window = {
        open = 'current',
        focus = 'first',
      },
      callbacks = {
        pre_open = function()
          -- Close toggleterm when an external open request is received
          require('toggleterm').toggle(0)
        end,
        post_open = function(bufnr, winnr, ft)
          vim.api.nvim_set_current_win(winnr)
        end,
        block_end = function()
          -- After blocking ends (for a git commit, etc), reopen the terminal
          require('toggleterm').toggle(0)
        end,
      },
    },
  },
}
