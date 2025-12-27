-- ~/.config/nvim/lua/plugins/writing.lua
return {
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = {
      { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 90,
        height = 1,
        options = {
          signcolumn = 'no',
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = '0',
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = false },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = {
          enabled = false,
          font = '+4',
        },
      },
    },
  },
  {
    'preservim/vim-pencil',
    ft = { 'markdown', 'text' },
    keys = {
      { 'yop', '<cmd>PencilToggle<cr>', desc = 'Toggle Pencil' },
    },
    config = function()
      vim.g['pencil#wrapModeDefault'] = 'soft'
      vim.g['pencil#textwidth'] = 80
      vim.g['pencil#joinspaces'] = 0
      vim.g['pencil#cursorwrap'] = 1
      vim.g['pencil#conceallevel'] = 0
      vim.g['pencil#concealcursor'] = ''
      vim.g['pencil#softDetectSample'] = 20
      vim.g['pencil#softDetectThreshold'] = 130

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown', 'text' },
        callback = function()
          vim.cmd('PencilHard')
        end,
      })
    end,
  },
  {
    'bullets-vim/bullets.vim',
    config = function()
      vim.g.bullets_enabled_file_types = { 'markdown', 'text' }

      local function bullets_ft_active(bufnr)
        local ft = vim.bo[bufnr].filetype
        local enabled_fts = vim.g.bullets_enabled_file_types
        if type(enabled_fts) ~= 'table' then
          return false
        end
        for _, v in ipairs(enabled_fts) do
          if v == ft then
            return true
          end
        end
        return false
      end

      local function is_bullet_line(bufnr)
        local line = vim.api.nvim_buf_get_lines(
          bufnr,
          vim.api.nvim_win_get_cursor(0)[1] - 1,
          vim.api.nvim_win_get_cursor(0)[1],
          false
        )[1] or ''
        return line:match('^%s*[%-%*]') ~= nil
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown', 'text' },
        callback = function(ev)
          local bufnr = ev.buf
          if not bullets_ft_active(bufnr) then
            return
          end

          local function termcodes(s)
            return vim.api.nvim_replace_termcodes(s, true, false, true)
          end

          local function blink_menu_visible()
            local ok, cmp = pcall(require, 'blink.cmp')
            return ok and cmp and cmp.is_visible and cmp.is_visible()
          end

          vim.keymap.set('i', '<Tab>', function()
            -- if completion UI is involved, don't touch it
            if vim.fn.pumvisible() == 1 or blink_menu_visible() then
              return termcodes('<Tab>')
            end
            if is_bullet_line(bufnr) then
              return termcodes('<C-o>:BulletDemote<CR>')
            end
            return termcodes('<Tab>')
          end, { buffer = bufnr, expr = true, noremap = false, silent = true })

          vim.keymap.set('i', '<S-Tab>', function()
            if vim.fn.pumvisible() == 1 or blink_menu_visible() then
              return termcodes('<S-Tab>')
            end
            if is_bullet_line(bufnr) then
              return termcodes('<C-o>:BulletPromote<CR>')
            end
            return termcodes('<S-Tab>')
          end, { buffer = bufnr, expr = true, noremap = false, silent = true })

          vim.keymap.set(
            'n',
            '<C-Space>',
            require('core.utils').make_repeatable_keymap('n', '<Plug>(bullets-toggle-checkbox)', function()
              vim.cmd('ToggleCheckbox')
            end),
            { buffer = bufnr, remap = true }
          )
        end,
      })
    end,
  },
}
