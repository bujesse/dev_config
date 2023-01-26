local M = {}

function M.config()
  require('bqf').setup({
    auto_resize_height = true,
    func_map = {
      drop = 'o',
      tabdrop = 't',
      ptoggleitem = 'p',
      ptogglemode = 'zp',
      prevhist = '<',
      nexthist = '>',
      stogglebuf = "'<Tab>", -- toggle signs for same buffers under the cursor
      sclear = 'z<Tab>', -- clear the signs in current quickfix list
      fzffilter = '/',
      filter = 'f', -- create new list for signed items
      filterr = 'F', -- create new list for non-signed items
    },
    filter = {
      fzf = {
        action_for = {
          ['enter'] = 'signtoggle',
        },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' }
      }
    }
  })
end

return M
