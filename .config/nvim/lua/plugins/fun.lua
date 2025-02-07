return {
  {
    'Eandrju/cellular-automaton.nvim',
    cmd = { 'CellularAutomaton' },
    init = function()
      vim.api.nvim_create_user_command('FML', 'CellularAutomaton make_it_rain', {})
    end,
  },
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    keys = {
      {
        '<leader>tt',
        '<cmd>Typr<CR>i',
        { desc = 'Typing Test', noremap = true, silent = true },
      },
    },
    cmd = { 'Typr', 'TyprStats' },
  },
}
