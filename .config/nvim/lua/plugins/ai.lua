local function accept_word()
  vim.fn['copilot#Accept']('')
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar, [[[ .]\zs]])[1]
end

local function accept_line()
  vim.fn['copilot#Accept']('')
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar, [[[\n]\zs]])[1]
end

return {
  -- AI
  {
    'github/copilot.vim',
    enabled = false,
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true
    end,
    keys = {
      { 'yoC', '<CMD>Copilot enable<CR>', desc = 'Enable Copilot' },
      { '<M-n>', '<Plug>(copilot-next)', mode = { 'i' } },
      { '<M-p>', '<Plug>(copilot-previous)', mode = { 'i' } },
      { '<C-Right>', accept_word, mode = { 'i' }, remap = false, expr = true },
      { '<C-l>', accept_line, mode = { 'i' }, remap = false, expr = true },
      { '<Right>', 'copilot#Accept("<CR>")', mode = { 'i' }, silent = true, expr = true },
    },
  },

  -- Lua Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    keys = {
      {
        'yoG',
        '<CMD>lua require("copilot.suggestion").toggle_auto_trigger()<CR>',
        desc = 'Toggle Copilot Auto-trigger',
      },
    },
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<Right>',
          accept_word = '<C-Right>',
          accept_line = '<C-l>',
          next = '<M-n>',
          prev = '<M-p>',
          dismiss = '<M-e>',
        },
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)

      local spinner = {
        max_length = 10,
        min_length = 1,
        max_distance_from_cursor = 1,
        max_lines = 1,
        repeat_ms = 250,

        -- stylua: ignore
        chars = {
          "꙽", "꙾", "ꙿ", "𐌀", "𐌁", "𐌂", "𐌃", "𐌄", "𐌅", "𐌆", "𐌇", "𐌈", "𐌉", "𐌊", "𐌋", "𐌌", "𐌍", "𐌎", "𐌏", "𐌐", "𐌑",
          "𐌒", "𐌓", "𐌔", "𐌕", "𓂀", "𓂁", "𓂂", "𓂃", "𓂄", "𓂅", "𓂆", "𓂇", "𓂈", "𓂉", "𓂊", "𓂋", "𓂌", "𓂍", "𓂎", "𓂏", "𓂐",
          "𓂑", "𓂒", "𓂓", "𓂔", "𓂕", "𓂖", "𓂗", "𓂘", "𓂙", "𓂚", "𓂛", "𓂜", "𓂝", "𓂞", "𓂟", "𓂠", "𓂡", "𓂢", "𓂣", "𓂤", "𓂥",
          "𓂦", "𓂧", "𓂨", "𓂩", "𓂪", "𓂫", "𓂬", "𓂭", "𓂮", "𓂯", "𓂰", "𓂱", "𓂲", "𓂳", "𓂴", "𓂵", "𓂶", "𓂷", "𓂸", "𓂹", "𓂺",
          "𓂻", "𓂼", "𓂽", "𓂾", "𓂿", "𓃀", "𓃁", "𓃂", "𓃃", "𓃄", "𓃅", "𓃆", "𓃇", "𓃈", "𓃉", "𓃊", "𓃋", "𓃌", "𓃍", "𓃎", "𓃏",
          "𓃐", "𓃑", "𓃒", "𓃓", "𓃔", "𓃕", "𓃖", "𓃗", "𓃘", "𓃙", "𓃚", "𓃛", "𓃜", "𓃝", "𓃞", "𓃟", "𓃠", "𓃡", "𓃢", "𓃣", "𓃤",
          "𓃥", "𓃦", "𓃧", "𓃨", "𓃩", "𓃪", "𓃯", "𓃰", "𓃱", "𓃲", "𓃳", "𓃴", "𓃵", "𓃶", "𓃷", "𓃸", "𓃹", "𓃺", "𓃻", "𓃼", "𓃽", "𓃾", "𓃿"
        },
        rand_hl_group = 'CopilotSpinnerHLGroup',
        ns = vim.api.nvim_create_namespace('custom_copilot_spinner'),
        timer = nil,
      }

      function spinner:next_string()
        local result = {}
        local spaces = math.random(0, self.max_distance_from_cursor)
        for _ = 1, spaces do
          table.insert(result, ' ')
        end

        local length = math.random(self.min_length, self.max_length)
        for _ = 1, length do
          local index = math.random(1, #self.chars)
          table.insert(result, self.chars[index])
        end

        return table.concat(result)
      end

      function spinner:reset()
        vim.api.nvim_buf_clear_namespace(0, self.ns, 0, -1)
        if self.timer then
          self.timer:stop()
          self.timer = nil
        end
      end

      vim.api.nvim_create_autocmd({ 'CursorMovedI', 'InsertLeave' }, {
        callback = function()
          spinner:reset()
        end,
      })

      require('copilot.status').register_status_notification_handler(function(data)
        spinner:reset()
        if data.status ~= 'InProgress' then
          return
        end

        if spinner.timer then
          spinner.timer:stop()
        end
        spinner.timer = vim.uv.new_timer()
        if not spinner.timer then
          return
        end

        spinner.timer:start(
          0,
          spinner.repeat_ms,
          vim.schedule_wrap(function()
            if require('copilot.suggestion').is_visible() then
              spinner:reset()
              return
            end

            local pos = vim.api.nvim_win_get_cursor(0)
            local cursor_row, cursor_col = pos[1] - 1, pos[2]
            local cursor_line = vim.api.nvim_buf_get_lines(0, cursor_row, cursor_row + 1, false)[1] or ''
            if cursor_col > #cursor_line then
              cursor_col = #cursor_line
            end

            vim.api.nvim_set_hl(0, spinner.rand_hl_group, {
              fg = '#' .. string.format('%02x', math.random(133, 255)) .. '0044',
              bold = true,
            })

            local extmark_ids = {}
            local num_lines = math.random(1, spinner.max_lines)
            local buf_line_count = vim.api.nvim_buf_line_count(0)

            for i = 1, num_lines do
              local row = cursor_row + i - 1
              if row >= buf_line_count then
                break
              end
              local col = (i == 1) and cursor_col or 0

              local extmark_id = vim.api.nvim_buf_set_extmark(0, spinner.ns, row, col, {
                virt_text = { { spinner:next_string(), spinner.rand_hl_group } },
                virt_text_pos = 'overlay',
                priority = 0,
              })
              table.insert(extmark_ids, extmark_id)
            end

            vim.defer_fn(function()
              for _, extmark_id in ipairs(extmark_ids) do
                pcall(vim.api.nvim_buf_del_extmark, 0, spinner.ns, extmark_id)
              end
            end, spinner.repeat_ms + math.random(1, 100))
          end)
        )
      end)
    end,
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    keys = {
      { '<Space>cc', '<CMD>CopilotChatToggle<CR>', desc = 'Toggle Copilot Chat', mode = { 'n', 'v' } },
      { '<Space>C', '<CMD>CopilotChatReset<CR>', desc = 'Toggle Copilot Chat', mode = { 'n', 'v' } },
      { '<Space>ce', '<CMD>CopilotChatExplain<CR>', desc = 'Explain', mode = { 'n', 'v' } },
      { '<Space>ct', '<CMD>CopilotChatTests<CR>', desc = 'Tests', mode = { 'n', 'v' } },
      { '<Space>cf', '<CMD>CopilotChatFix<CR>', desc = 'Fix', mode = { 'n', 'v' } },
      { '<Space>cr', '<CMD>CopilotChatOptimize<CR>', desc = 'Optimize', mode = { 'n', 'v' } },
      { '<Space>cd', '<CMD>CopilotChatDocs<CR>', desc = 'Docs', mode = { 'n', 'v' } },
      { '<Space>cF', '<CMD>CopilotChatFixDiagnostic<CR>', desc = 'Fix Diagnostic', mode = { 'n', 'v' } },
      { '<Space>cm', '<CMD>CopilotChatCommitStaged<CR>', desc = 'Commit message for staged', mode = { 'n', 'v' } },
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
