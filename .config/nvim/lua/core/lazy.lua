local M = {}

M.config = function()
  -- Load everything in lua/plugins/
  require("lazy").setup('plugins', {
    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = true,
      notify = false,
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
