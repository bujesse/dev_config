local M = {}

function M.grep_string_visual()
  local visual_selection = require('core.utils').selected_text()
  print('Search string: ' .. visual_selection)
  -- Treat the pattern as a literal string instead of a regular expression.
  require('telescope.builtin').grep_string({ search = visual_selection, use_regex = false })
end

function M.print_visual()
  local visual_selection = require('core.utils').selected_text()
  vim.cmd([[messages clear]])
  print(visual_selection .. '\n \n ')
end

function M.path_display(opts, file)
  -- Format path as "file.txt (path\to\file)"
  -- local Path = require('plenary.path')
  local tele_utils = require('telescope.utils')
  local sep = require('core.utils').sep
  local tail = tele_utils.path_tail(file)
  local path = tele_utils.path_smart(file)
  -- path = Path:new(path):shorten(3) -- how many chars to shorten to
  path = vim.split(path, sep)
  table.remove(path)
  path = table.concat(path, sep)
  return string.format('%s (%s)', tail, path)
end

function M.entry_maker(entry)
  local entry_display = require('telescope.pickers.entry_display')
  local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 3 },
      { remaining = true },
    },
  })

  local make_display = function(e)
    return displayer({
      e.lnum,
      M.path_display(nil, e.filename),
    })
  end

  return {
    valid = true,
    value = entry,
    ordinal = filename .. ' ' .. entry.text,
    display = make_display,
    bufnr = entry.bufnr,
    filename = filename,
    lnum = entry.lnum,
    col = entry.col,
    text = entry.text,
    start = entry.start,
    finish = entry.finish,
  }
end

local opts_cursor = {
  sorting_strategy = 'ascending',
  layout_strategy = 'cursor',
  results_title = false,
  layout_config = {
    width = 0.9,
    height = 0.5,
  },
}

local opts_vertical = {
  sorting_strategy = 'ascending',
  layout_strategy = 'vertical',
  results_title = false,
  layout_config = {
    width = 0.4,
    height = 0.6,
    prompt_position = 'top',
    mirror = true,
  },
}

function M.config()
  local actions = require('telescope.actions')
  require('telescope').setup({
    defaults = {
      path_display = { 'smart' },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
      },
      mappings = {
        i = {
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,
          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,
          ['<esc>'] = actions.close,
        },
      },
      layout_strategy = 'horizontal',
      winblend = 15,
      file_ignore_patterns = {
        '*.git/*',
        '*/tmp/*',
        '*.cache/*',
        '*plugged/*',
        'packer_compiled.lua',
        'node_modules/',
        'package-lock.json',
        'plug.vim',
        'plug.vim.old',
        'Wilder*',
        'disabled/*',
        'sessions/*',
      },
      cache_picker = {
        num_pickers = 5,
      },
    },
    pickers = {
      buffers = {
        sort_mru = true,
        preview_title = false,
      },
      lsp_code_actions = vim.tbl_deep_extend('force', opts_cursor, {}),
      lsp_range_code_actions = vim.tbl_deep_extend('force', opts_vertical, {}),
      lsp_document_diagnostics = vim.tbl_deep_extend('force', opts_vertical, {}),
      lsp_implementations = vim.tbl_deep_extend('force', opts_cursor, {}),
      lsp_definitions = vim.tbl_deep_extend('force', opts_cursor, {
        entry_maker = M.entry_maker,
      }),
      lsp_references = vim.tbl_deep_extend('force', opts_cursor, {
        entry_maker = M.entry_maker,
      }),
      live_grep = {
        additional_args = function(opts)
          if opts.mode == 'filetype_mask' then
            -- Filetype mask
            local filetype = vim.fn.input('Filetype Mask: ', '', 'customlist,bu#get_rg_type_list')
            if filetype == '' then
              return {}
            end
            local colon_idx = string.find(filetype, ':', 1, true)
            if colon_idx ~= nil then
              filetype = string.sub(filetype, 1, colon_idx - 1)
            end
            filetype = '-t' .. filetype
            vim.api.nvim_command('redraw')
            print('Using rg additional arg: ' .. filetype)
            return { filetype }
          elseif opts.mode == 'ignore' then
            return { '--no-ignore', '--hidden' }
          end
          return {}
        end,
      },
    },
    extensions = {
    },
  })

  local opts = {
    noremap = true,
    silent = true,
  }

  -- Essential
  vim.api.nvim_set_keymap('n', '<Space>\'', '<cmd>lua require("telescope.builtin").resume()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Space>o', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Space>f',
    '<cmd>lua require("telescope.builtin").live_grep({ additional_args = { "--fixed-strings" } })<CR>',
    opts)
  vim.api.nvim_set_keymap('n', '<Space>g', '<cmd>lua require("telescope.builtin").git_status()<CR>', opts)
  vim.api.nvim_set_keymap(
    'n',
    '<Space>m',
    '<cmd>lua require("telescope.builtin").oldfiles({include_current_session = true})<CR>',
    opts
  )
  vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gy', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>', opts)

  -- Custom
  vim.api.nvim_set_keymap(
    'n',
    '<Space>O',
    '<cmd>lua require("telescope.builtin").find_files({ hidden = true })<CR>',
    opts
  )
  vim.api.nvim_set_keymap(
    'n',
    '<Space>F',
    '<cmd>lua require("telescope.builtin").live_grep({mode = "filetype_mask"})<CR>',
    opts
  )

  vim.api.nvim_set_keymap(
    'n',
    '<Space>d',
    '<cmd>lua require("telescope.builtin").live_grep({cwd = require("telescope.utils").buffer_dir()})<CR>',
    opts
  )

  vim.api.nvim_set_keymap('x', '<Space>f', '<cmd>lua require("plugins.telescope").grep_string_visual()<CR>', opts)

  vim.api.nvim_set_keymap('x', '<Leader>y', '<cmd>lua require("plugins.telescope").print_visual()<CR>', opts)

  -- which-key mappings (used less often, so put behind a 3-char input)
  require('which-key').register({
    name = '+telescope',
    -- f = { '<cmd>lua require("telescope").extensions.frecency.frecency()<CR>', 'Frecency' },
    j = { '<cmd>lua require("telescope.builtin").jumplist()<CR>', 'Jumplist' },
    b = { '<cmd>lua require("telescope.builtin").buffers()<CR>', 'Buffers' },
    p = { '<cmd>lua require("telescope.builtin").pickers()<CR>', 'Pickers' },
    i = {
      '<cmd>lua require("telescope.builtin").live_grep({mode = "ignore"})<CR>',
      'Grep (include ignore and hidden)',
    },
    r = { '<cmd>lua require("telescope.builtin").live_grep()<CR>', 'Regex Search' },
    u = { '<cmd>lua require("telescope.builtin").grep_string()<CR>', 'Grep String (under cursor)' },
    c = { '<cmd>lua require("telescope.builtin").commands()<CR>', 'Commands' },
    h = { '<cmd>lua require("telescope.builtin").command_history()<CR>', 'Command History' },
    v = { '<cmd>lua require("telescope.builtin").vim_options()<CR>', 'Vim Options' },
    s = { '<cmd>lua require("telescope.builtin").spell_suggest()<CR>', 'Spell Suggest (under cursor)' },
    k = { '<cmd>lua require("telescope.builtin").keymaps()<CR>', 'Keymaps' },
    t = { '<cmd>lua require("telescope.builtin").treesitter()<CR>', 'Treesitter' },
    g = {
      name = '+git',
      c = { '<cmd>lua require("telescope.builtin").git_commits()<CR>', 'Git Commits' },
      b = { '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', 'Git Buffer Commits' },
      r = { '<cmd>lua require("telescope.builtin").git_branches()<CR>', 'Git Branches' },
      s = { '<cmd>lua require("telescope.builtin").git_status()<CR>', 'Git Status' },
    },
  }, {
    prefix = '<Space>t',
  })
end

return M
