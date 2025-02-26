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
  ath = vim.split(path, sep)
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

local in_git_repo = function()
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    return true
  else
    return false
  end
end

function M.config()
  local actions = require('telescope.actions')
  local builtin = require('telescope.builtin')

  local picker_map = {
    ['Git Files'] = builtin.git_files,
    ['Find Files'] = builtin.find_files,
    ['Live Grep'] = function(opts)
      -- spread opts into the live_grep function
      opts = opts or {}
      opts.additional_args = { '--fixed-strings' }
      require('telescope').extensions.menufacture.live_grep(opts)
    end,
  }

  local get_pickers_to_cycle = function()
    local ordered_pickers = {
      'Find Files',
      'Live Grep',
    }
    local pickers_to_cycle = {}
    local i = 1
    for _, title in ipairs(ordered_pickers) do
      pickers_to_cycle[i] = title
      i = i + 1
    end
    return pickers_to_cycle
  end

  local next_picker = function(prompt_bufnr)
    local pickers_to_cycle = get_pickers_to_cycle()
    local state = require('telescope.actions.state')
    local current_picker = state.get_current_picker(prompt_bufnr)

    local next_index = 1
    for i, title in ipairs(pickers_to_cycle) do
      if title == current_picker.prompt_title then
        next_index = i + 1
        if next_index > #pickers_to_cycle then
          next_index = 1
        end
        break
      end
    end
    local next_title = pickers_to_cycle[next_index]
    local new_picker = picker_map[next_title]
    return new_picker({ ['default_text'] = state.get_current_line() })
  end

  local prev_picker = function(prompt_bufnr)
    local pickers_to_cycle = get_pickers_to_cycle()
    local state = require('telescope.actions.state')
    local current_picker = state.get_current_picker(prompt_bufnr)

    local prev_index = 1
    for i, title in ipairs(pickers_to_cycle) do
      if title == current_picker.prompt_title then
        prev_index = i - 1
        if prev_index == 0 then
          prev_index = #pickers_to_cycle
        end
        break
      end
    end
    local prev_title = pickers_to_cycle[prev_index]
    local new_picker = picker_map[prev_title]
    return new_picker({ ['default_text'] = state.get_current_line() })
  end

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
          ['<C-f>'] = actions.to_fuzzy_refine,
          ['<A-n>'] = next_picker,
          ['<A-p>'] = prev_picker,
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
      -- file_previewer = require('telescope.previewers').cat.new,
      -- grep_previewer = require('telescope.previewers').vimgrep.new,
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
          toggle_hidden = { i = '<C-h>' },
          toggle_no_ignore = { i = '<C-i>' },
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
      undo = {
        mappings = {
          i = {
            ['<cr>'] = require('telescope-undo.actions').restore,
            ['<C-y>'] = require('telescope-undo.actions').yank_deletions,
            ['<C-r>'] = require('telescope-undo.actions').yank_additions,
          },
        },
        side_by_side = true,
        -- layout_strategy = 'vertical',
        -- layout_config = {
        --   preview_height = 0.8,
        -- },
        vim_diff_opts = {
          ctxlen = vim.o.scrolloff,
        },
      },
    },
  })

  require('telescope').load_extension('fzf')
  require('telescope').load_extension('menufacture')
  require('telescope').load_extension('recent_files')
  -- require('telescope').load_extension('frecency')
  require('telescope').load_extension('scope')
  require('telescope').load_extension('undo')

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
  vim.keymap.set(
    'n',
    '<Space>m',
    '<Cmd>lua require("telescope").extensions.recent_files.pick({ only_cwd = true })<CR>',
    { desc = 'Recent Files' }
  )
  vim.keymap.set(
    'n',
    '<Space>u',
    '<Cmd>lua require("telescope").extensions.undo.undo({ side_by_side = true })<CR>',
    { desc = 'Undo' }
  )

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
  require('which-key').add({
    { '<Space>t', group = 'Telescope' },
    {
      '<Space>tS',
      '<cmd>lua require("telescope.builtin").spell_suggest()<CR>',
      desc = 'Spell Suggest (under cursor)',
    },
    { '<Space>ta', '<cmd>lua require("telescope.builtin").autocommands()<CR>', desc = 'Autocommands' },
    { '<Space>tb', '<cmd>lua require("telescope.builtin").buffers()<CR>', desc = 'Scope Buffers' },
    { '<Space>tB', '<cmd>Telescope scope buffers<CR>', desc = 'All Buffers' },
    { '<Space>tg', group = 'git' },
    { '<Space>tgb', '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', desc = 'Git Buffer Commits' },
    { '<Space>tgc', '<cmd>lua require("telescope.builtin").git_commits()<CR>', desc = 'Git Commits' },
    { '<Space>tgr', '<cmd>lua require("telescope.builtin").git_branches()<CR>', desc = 'Git Branches' },
    { '<Space>tgs', '<cmd>lua require("telescope.builtin").git_status()<CR>', desc = 'Git Status' },
    { '<Space>th', '<cmd>lua require("telescope.builtin").command_history()<CR>', desc = 'Command History' },
    {
      '<Space>ti',
      '<cmd>lua require("telescope").extensions.menufacture.live_grep({mode = "ignore"})<CR>',
      desc = 'Grep (include ignore and hidden)',
    },
    { '<Space>tj', '<cmd>lua require("telescope.builtin").jumplist()<CR>', desc = 'Jumplist' },
    { '<Space>tk', '<cmd>lua require("telescope.builtin").keymaps()<CR>', desc = 'Keymaps' },
    { '<Space>tl', '<cmd>lua require("telescope.builtin").highlights()<CR>', desc = 'HighLights' },
    { '<Space>tr', '<cmd>lua require("telescope").extensions.menufacture.live_grep()<CR>', desc = 'Regex Search' },
    {
      '<Space>ts',
      '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>',
      desc = 'Lsp Document Symbols',
    },
    { '<Space>tu', '<cmd>lua require("telescope").extensions.menufacture.grep_string()<CR>', desc = 'Grep String' },
    { '<Space>tv', '<cmd>lua require("telescope.builtin").vim_options()<CR>', desc = 'Vim Options' },
  }, {
    prefix = '<Space>t',
  })
end

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Leet',
  opts = {},
  -- dependencies = {
  -- 'plenary.nvim',
  -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  -- 'molecule-man/telescope-menufacture',
  -- -- { 'nvim-telescope/telescope-frecency.nvim' },
  -- { 'smartpde/telescope-recent-files' },
  -- 'tiagovla/scope.nvim',
  -- { 'debugloop/telescope-undo.nvim' },
  -- },
  config = function()
    -- M.config()
  end,
}
