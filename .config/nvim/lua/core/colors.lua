local colors = vim.fn['gruvbox_material#get_palette'](vim.g.gruvbox_target_background, vim.g.gruvbox_target_palette)

-- Reduce to only the hex values (gruvbox_material returns 2 values)
colors = require('core.utils').map(colors, function(item)
  return item[1]
end)
return colors
