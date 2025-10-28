return {
  -- Language specific plugins
  -- typescript
  {
    'pmizio/typescript-tools.nvim',
    enabled = false,
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeCompletionsForModuleExports = true,
          quotePreference = 'auto',
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
      },
    },
  },

  -- rust
  {
    'simrat39/rust-tools.nvim',
    enabled = false,
    config = function()
      local rt = require('rust-tools')
      -- make sure to install coddelldb with mason, and update these paths
      local extension_path = '/home/bujesse/.local/share/nvim/mason/packages/codelldb/extension/'
      local codelldb_path = extension_path .. 'adapter/codelldb'
      local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

      rt.setup({
        dap = {
          adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
          end,
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
      })
    end,
  },

  -- golang
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

  -- tailwind css
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- optional
      'neovim/nvim-lspconfig', -- optional
    },
    opts = {
      server = {
        override = false, -- setup the server from the plugin if true
        settings = {}, -- shortcut for `settings.tailwindCSS`
        on_attach = function(client, bufnr) end, -- callback triggered when the server attaches to a buffer
      },
      document_color = {
        enabled = false, -- can be toggled by commands
        kind = 'inline', -- "inline" | "foreground" | "background"
        inline_symbol = '󰝤 ', -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      cmp = {
        highlight = 'background', -- color preview style, "foreground" | "background"
      },
    }, -- your configuration
    keys = {
      { 'yoT', '<cmd>TailwindConcealToggle<CR>', desc = 'Toggle TailwindCSS Concealer' },
      { '<Space>tT', '<cmd>Telescope tailwind classes<CR>', desc = 'Search TailwindCSS classes' },
    },
  },

  -- format tailwind css on save
  {
    'laytan/tailwind-sorter.nvim',
    enabled = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
    build = 'cd formatter && npm ci && npm run build',
    opts = {
      on_save_enabled = true,
      on_save_pattern = { '*.templ' },
    },
  },
}
