return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
      'hrsh7th/nvim-cmp',
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    keys = {
      { '<leader>dd', '<CMD>DBUIToggle<CR>', desc = 'Toggle DBUI' },
      { '<leader>di', '<CMD>DBUILastQueryInfo<CR>', desc = 'Info about last query' },
      { '<leader>ds', '<Plug>(DBUI_SaveQuery)', desc = 'Save Query', ft = 'mysql' },
      { '<CR>', '<Plug>(DBUI_ExecuteQuery)', desc = 'Execute Query', ft = 'mysql' },
      { '<leader>N', '<CMD>DBUIFindBuffer<CR>', desc = 'Locate buffer', ft = 'mysql' },
      { '<CR>', '<Plug>(DBUI_JumpToForeignKey)', desc = 'Execute Query', ft = 'dbout' },
      { 'l', '<Plug>(DBUI_GotoChildNode)', desc = 'Go to Child Node', ft = 'dbui' },
      { 'h', '<Plug>(DBUI_GotoParentNode)', desc = 'Go to Parent Node', ft = 'dbui' },
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_win_position = 'right'

      vim.cmd([[
        let g:dbs = {
        \ 'local': 'mysql://backup.superuser:Wealth01@127.0.0.1:3306/',
        \ }
      ]])

      vim.api.nvim_command([[
        autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
      ]])
    end,
  },
}
