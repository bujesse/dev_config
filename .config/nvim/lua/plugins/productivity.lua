return {
  {
    'epwalsh/obsidian.nvim',
    opts = {
      dir = '/projects/obsidian-vault/home-vault/',
      note_id_func = function(title)
        return title
      end,
      completion = {
        nvim_cmp = true,
      },
      notes_subdir = 'notes',
      daily_notes = {
        folder = 'notes/dailies',
      },
    },
    ft = 'markdown',
    keys = {
      { '<Leader>ob', '<CMD>ObsidianBacklinks<CR>' },
      { '<Leader>ot', '<CMD>ObsidianToday<CR>' },
      { '<Leader>oy', '<CMD>ObsidianYesterday<CR>' },
      { '<Leader>oo', '<CMD>ObsidianQuickSwitch<CR>', desc = 'Obsidian Quick Switch' },
      { '<Leader>os', '<CMD>ObsidianSearch<CR>', desc = 'Obsidian Search' },
      { '<Leader>on', ':ObsidianNew ', desc = 'Create a new note' },
      { '<Leader>ol', ':ObsidianLinkNew ', desc = 'Create link to new note', mode = { 'v' } },
    },
    config = function(_, opts)
      require('obsidian').setup(opts)
      local augroup = vim.api.nvim_create_augroup('_markdown', { clear = false })
      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        pattern = 'markdown',
        callback = function()
          vim.keymap.set('n', '<CR>', function()
            if require('obsidian').util.cursor_on_markdown_link() then
              vim.cmd([[ObsidianFollowLink]])
            else
              vim.cmd([[MkdnFollowLink]])
            end
          end, { buffer = true })
        end,
      })
      vim.api.nvim_create_autocmd('InsertLeave', {
        group = augroup,
        pattern = '*.md',
        callback = function()
          local row = vim.api.nvim_win_get_cursor(0)[1]
          local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
          local in_table = require('mkdnflow.tables').isPartOfTable(line)
          if in_table then
            vim.cmd([[MkdnTableFormat]])
          end
        end,
      })
    end,
  },

  {
    'jakewvincent/mkdnflow.nvim',
    -- rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
    opts = {
      to_do = {
        symbols = { ' ', 'x', '-' },
      },
      mappings = {
        MkdnToggleToDo = { { 'n', 'v' }, 'ga' },
        MkdnFoldSection = { { 'n' }, 'zC' },
        MkdnUnfoldSection = { { 'n' }, 'zO' },
        MkdnNewListItem = { 'i', '<CR>' }, -- only want <CR> in insert mode to add a new list item (and behave as usual outside of lists).
        -- MkdnEnter = { { 'i' }, '<CR>' }, -- only want <CR> in insert mode to add a new list item (and behave as usual outside of lists).
        MkdnEnter = false,
        MkdnTab = { { 'i' }, '<C-l>' },
        MkdnSTab = { { 'i' }, '<C-h>' },
        MkdnTablePrevRow = { 'i', '<C-k>' },
        MkdnTableNextRow = { 'i', '<C-j>' },
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnFollowLink = false,
      },
    },
  },
}
