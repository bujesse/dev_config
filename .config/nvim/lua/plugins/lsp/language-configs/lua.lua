local M = {
  formatters = {
    {
      exe = 'stylua',
      args = {
        '--indent-type', 'Spaces',
        '--indent-width', '2',
        '--quote-style', 'AutoPreferSingle',
      },
    },
  },
}

return M
