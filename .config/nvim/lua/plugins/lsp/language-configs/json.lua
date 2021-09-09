local schemas = nil
local status_ok, jsonls_settings = pcall(require, 'nlspsettings.jsonls')
if status_ok then
  schemas = jsonls_settings.get_default_schemas()
end

local config = {
  formatters = {
    -- {
    --   exe = "json_tool",
    --   args = {},
    -- },
    -- {
    --   exe = "prettier",
    --   args = {},
    -- },
    -- {
    --   exe = "prettierd",
    --   args = {},
    -- },
  },
  linters = {},
  lsp = {
    provider = 'jsonls',
    setup = {
      cmd = {
        'node',
        DATA_PATH .. '/lspinstall/json/vscode-json/json-language-features/server/dist/node/jsonServerMain.js',
        '--stdio',
      },
      after_on_attach = function(client, bufnr)
        -- Regular formatting doesn't work properly, so we need to use range_formatting instead
        -- TODO: doing it like this only applies these settings to
        local format_fn = "lua vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })"
        vim.api.nvim_buf_set_keymap(
          bufnr,
          'n',
          '<Leader>af',
          '<cmd>' .. format_fn .. '<CR>',
          { noremap = true, silent = true }
        )

        -- Swap out autoformat command
        -- NOTE: toggle not implemented; always autoformat JSON
        -- Turn off autoformat, but flip the flag, so it can be toggled back to what it was before forcing off
        require('plugins.lsp.utils').temp_off()
        require('core.autocommands').define_augroups({
          json_autoformat = {
            {
              'BufEnter',
              '*.json',
              ':lua require("plugins.lsp.utils").temp_off()',
            },
            {
              'BufLeave',
              '*.json',
              ':lua require("plugins.lsp.utils").toggle_autoformat(0)',
            },
            {
              'BufWritePre',
              '*.json',
              ':' .. format_fn,
            },
            -- This is a hack, but the format fn leaves the file dirty, so write again afterwards to remove that flag
            {
              'BufWritePost',
              '*.json',
              [[call timer_start(100, {-> execute("noautocmd write", "")})]],
            },
          },
        })
      end,
      settings = {
        json = {
          schemas = schemas,
          --   = {
          --   {
          --     fileMatch = { "package.json" },
          --     url = "https://json.schemastore.org/package.json",
          --   },
          -- },
        },
      },
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
          end,
        },
      },
    },
  },
}

return config
