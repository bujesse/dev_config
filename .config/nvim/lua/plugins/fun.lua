return {
  {
    'Eandrju/cellular-automaton.nvim',
    cmd = { 'CellularAutomaton' },
    init = function()
      vim.api.nvim_create_user_command('FML', 'CellularAutomaton make_it_rain', {})
    end,
  },
}
