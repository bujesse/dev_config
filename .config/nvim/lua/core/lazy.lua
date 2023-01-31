local M = {}

M.config = function()
  -- Load everything in lua/plugins/
  require("lazy").setup('plugins', {
    git = {
      -- defaults for the `Lazy log` command
      log = { "-5" }, -- show the last 5 commits
      -- log = { "--since=3 days ago" }, -- show commits from the last 3 days
    },
    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = true,
      notify = false,
    },
    install = {
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { 'kanagawa' },
    },
    ui = {
      icons = {
        cmd = "⌘",
        config = "🛠",
        event = "📅",
        ft = "📂",
        init = "⚙",
        keys = "🗝",
        plugin = "🔌",
        runtime = "💻",
        source = "📄",
        start = "🚀",
        task = "📌",
        lazy = "💤 ",
      }
    },
  })
end

return M
