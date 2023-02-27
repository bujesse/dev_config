return {
  {
    'epwalsh/obsidian.nvim',
    opts = {
      dir = '/mnt/c/Users/Jesse/obsidian-vault/home-vault/',
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        local suffix = ''
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. '-' .. suffix
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
              return '<cmd>ObsidianFollowLink<CR>'
            else
              return '<CR>'
            end
          end, { buffer = true })
        end,
      })
    end,
  },

  {
    'jakewvincent/mkdnflow.nvim',
    -- rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
    opts = {
      to_do = {
        symbols = { ' ', '⧗', 'x' },
      },
      mappings = {
        MkdnToggleToDo = { { 'n', 'v' }, '<C-Space>' },
        MkdnFoldSection = { { 'n' }, 'zC' },
        MkdnUnfoldSection = { { 'n' }, 'zO' },
        MkdnNewListItem = { 'i', '<CR>' }, -- only want <CR> in insert mode to add a new list item (and behave as usual outside of lists).
        MkdnTab = { { 'n', 'i' }, '<Tab>' },
        MkdnSTab = { { 'n', 'i' }, '<S-Tab>' },
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnFollowLink = { 'n', '<CR>' },
        MkdnEnter = false,
      },
    },
  },
}
