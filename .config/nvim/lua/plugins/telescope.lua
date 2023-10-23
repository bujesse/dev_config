local M = {}

function M.grep_string_visual()
  local visual_selection = require('core.utils').selected_text()
  print('Search string: ' .. visual_selection)
  -- Treat the pattern as a literal string instead of a regular expression.
  -- require('telescope.builtin').grep_string({ search = visual_selection, use_regex = false })
  require('telescope').extensions.menufacture.grep_string({ search = visual_selection, use_regex = false })
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

-- Run a command starting with ':'
local function run_selection(prompt_bufnr, map)
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local selection = action_state.get_selected_entry()
  if string.sub(selection.display, 1, 1) == ':' then
    actions.close(prompt_bufnr)
    vim.cmd(selection.display)
  end
end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'molecule-man/telescope-menufacture',
    { 'nvim-telescope/telescope-frecency.nvim' },
  },
  config = function()
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
            ['<C-v>'] = actions.select_vertical,
            ['<C-x>'] = actions.select_horizontal,
            ['<C-t>'] = actions.select_tab,
            ['<C-f>'] = actions.to_fuzzy_refine, -- Very useful
            ['<C-g>'] = function(prompt_bufnr)
              -- Use nvim-window-picker to choose the window by dynamically attaching a function
              local action_set = require('telescope.actions.set')
              local action_state = require('telescope.actions.state')

              local picker = action_state.get_current_picker(prompt_bufnr)
              picker.get_selection_window = function(picker, entry)
                local picked_window_id = require('window-picker').pick_window() or vim.api.nvim_get_current_win()
                -- Unbind after using so next instance of the picker acts normally
                picker.get_selection_window = nil
                return picked_window_id
              end

              return action_set.edit(prompt_bufnr, 'edit')
            end,
          },
        },
        layout_strategy = 'horizontal',
        winblend = 15,
        file_ignore_patterns = {
          -- lock files
          '*-lock.*',

          '*.git/*',
          '*/tmp/*',
          '*.cache/*',
          '*plugged/*',
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
        file_previewer = require('telescope.previewers').cat.new,
        grep_previewer = require('telescope.previewers').vimgrep.new,
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
              vim.api.nvim_command('redraw')
              print('Using rg additional arg: -t ' .. filetype)
              return { '-t', filetype }
            elseif opts.mode == 'ignore' then
              return { '--no-ignore', '--hidden' }
            end
            return {}
          end,
        },
        help_tags = {
          prompt_title = 'Help Tags (<C-i> to run a command starting with :)',
          mappings = {
            i = {
              ['<C-i>'] = run_selection,
            },
          },
        },
      },
      extensions = {
        menufacture = {
          mappings = {
            main_menu = { [{ 'i', 'n' }] = '<C-e>' },
          },
        },
        frecency = {
          show_scores = true,
          show_unindexed = true,
          ignore_patterns = { '*.git/*', '*/tmp/*' },
          disable_devicons = false,
          workspaces = {
            ['execution'] = '/home/vagrant/dev/execution',
            ['execution-ui'] = '/home/vagrant/dev/execution-ui',
            ['nvim'] = '/home/vagrant/dev_config/.config/nvim',
          },
        },
      },
    })

    require('telescope').load_extension('fzf')
    require('telescope').load_extension('menufacture')
    require('telescope').load_extension('frecency')

    -- Essential
    vim.keymap.set('n', "<Space>'", '<cmd>lua require("telescope.builtin").resume()<CR>', { desc = 'Telescope Resume' })
    vim.keymap.set(
      'n',
      '<Space>o',
      '<cmd>lua require("telescope").extensions.menufacture.find_files()<CR>',
      { desc = 'Find Files' }
    )
    vim.keymap.set(
      'n',
      '<Space>f',
      '<cmd>lua require("telescope").extensions.menufacture.live_grep({ additional_args = { "--fixed-strings" } })<CR>',
      { desc = 'Global Search (Fixed Strings)' }
    )
    vim.keymap.set(
      'n',
      '<Space>g',
      '<cmd>lua require("telescope.builtin").git_status()<CR>',
      { desc = 'Telescope Git Status' }
    )
    vim.keymap.set('n', '<Space>m', '<Cmd>Telescope frecency workspace=CWD<CR>', { desc = 'Frecency' })

    -- Currently using Glance for goto lsp
    -- vim.keymap.set('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', { desc = 'Lsp References' })
    -- vim.keymap.set(
    --   'n',
    --   'gd',
    --   '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>',
    --   { desc = 'Lsp Definitions' }
    -- )
    -- vim.keymap.set(
    --   'n',
    --   'gy',
    --   '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>',
    --   { desc = 'Lsp Type Definitions' }
    -- )

    vim.keymap.set(
      'n',
      '<Space>S',
      '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>',
      { desc = 'Lsp Workspace Symbols' }
    )

    vim.keymap.set('n', '<Space>h', '<cmd>lua require("telescope.builtin").help_tags()<CR>', { desc = 'Help Tags' })

    -- Custom
    vim.keymap.set(
      'n',
      '<Space>O',
      '<cmd>lua require("telescope").extensions.menufacture.find_files({ hidden = true })<CR>',
      { desc = 'Find Files (Hidden)' }
    )
    vim.keymap.set(
      'n',
      '<Space>F',
      '<cmd>lua require("telescope").extensions.menufacture.live_grep({mode = "filetype_mask"})<CR>',
      { desc = 'Global Search (Filetype Mask)' }
    )

    vim.keymap.set('n', '<Space>j', '<cmd>lua require("telescope.builtin").jumplist()<CR>', { desc = 'Jumplist' })

    vim.keymap.set('n', '<Space>p', '<cmd>lua require("telescope.builtin").pickers()<CR>', { desc = 'Pickers' })

    -- This will allow easy access to hard-to-remember, obscure commands through mappings
    -- TODO: this needs work, as just the commands aren't good enough for <space><space>
    vim.keymap.set(
      'n',
      '<Space><Space>',
      [[<cmd>lua require("telescope.builtin").commands(require("telescope.themes").get_dropdown({ layout_config = { width = 0.7, height = 0.7, } }))<cr>]],
      { desc = 'Commands' }
    )

    vim.keymap.set('x', '<Space>f', M.grep_string_visual, { desc = 'Search Visual String' })

    -- which-key mappings (used less often, so put behind a 3-char input)
    require('which-key').register({
      name = '+Telescope',
      -- f = { '<cmd>lua require("telescope").extensions.frecency.frecency()<CR>', 'Frecency' },
      j = { '<cmd>lua require("telescope.builtin").jumplist()<CR>', 'Jumplist' },
      a = { '<cmd>lua require("telescope.builtin").autocommands()<CR>', 'Autocommands' },
      l = { '<cmd>lua require("telescope.builtin").highlights()<CR>', 'HighLights' },
      b = { '<cmd>lua require("telescope.builtin").buffers()<CR>', 'Buffers' },
      h = { '<cmd>lua require("telescope.builtin").command_history()<CR>', 'Command History' },
      i = {
        '<cmd>lua require("telescope").extensions.menufacture.live_grep({mode = "ignore"})<CR>',
        'Grep (include ignore and hidden)',
      },
      r = { '<cmd>lua require("telescope").extensions.menufacture.live_grep()<CR>', 'Regex Search' },
      u = { '<cmd>lua require("telescope").extensions.menufacture.grep_string()<CR>', 'Grep String' },
      v = { '<cmd>lua require("telescope.builtin").vim_options()<CR>', 'Vim Options' },
      s = { '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', 'Lsp Document Symbols' },
      S = { '<cmd>lua require("telescope.builtin").spell_suggest()<CR>', 'Spell Suggest (under cursor)' },
      k = { '<cmd>lua require("telescope.builtin").keymaps()<CR>', 'Keymaps' },
      t = { '<cmd>TodoTelescope<cr>', 'Todo' },
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
  end,
}
