return {
  {
    'Willem-J-an/adopure.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      vim.g.adopure = {
        pat_token = '',
      }
    end,
    keys = {
      { '<leader>Ac', '<CMD>AdoPure load context<CR>', desc = 'AdoPure Load Context' },
    },
  },
}
