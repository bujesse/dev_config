local M = {}

M.bubbly_palette = function ()
  return {
      -- aqua = "#8bba7f",
      -- bg0 = "#282828",
      -- bg1 = "#32302f",
      -- bg2 = "#32302f",
      -- bg3 = "#45403d",
      -- bg4 = "#45403d",
      -- bg5 = "#5a524c",
      -- bg_current_word = "#3c3836",
      -- bg_diff_blue = "#0e363e",
      -- bg_diff_green = "#34381b",
      -- bg_diff_red = "#402120",
      -- bg_green = "#b0b846",
      -- bg_red = "#db4740",
      -- bg_statusline1 = "#32302f",
      -- bg_statusline2 = "#3a3735",
      -- bg_statusline3 = "#504945",
      -- bg_visual_blue = "#374141",
      -- bg_visual_green = "#3b4439",
      -- bg_visual_red = "#4c3432",
      -- bg_visual_yellow = "#4f422e",
      -- bg_yellow = "#e9b143",
      -- fg0 = "#e2cca9",
      -- fg1 = "#e2cca9",
      -- grey0 = "#7c6f64",
      -- grey1 = "#928374",
      -- grey2 = "#a89984",
      -- none = "NONE",
      -- orange = "#f28534",
    white = "#c5cdd9",
  }
end

M.config = function()
  -- Here you can add the configuration for the plugin
  vim.g.bubbly_palette = M.bubbly_palette()
  vim.g.bubbly_statusline = {
    'mode',

    'truncate',

    'path',
    'branch',
    'signify',
    'coc',

    'divisor',

    'filetype',
    'progress',
  }
end

M.bubbly_palette()

return M
