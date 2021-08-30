vim.opt.termguicolors = true
require('bufferline').setup{}

vim.api.nvim_set_keymap('n', 'gb', ':BufferLinePick<CR>', { noremap=true, silent=true, })
vim.api.nvim_set_keymap('n', ']b', ':BufferLineCycleNext<CR>', { noremap=true, silent=true, })
vim.api.nvim_set_keymap('n', '[b', ':BufferLineCyclePrev<CR>', { noremap=true, silent=true, })
vim.api.nvim_set_keymap('n', '<C-Left>', ':BufferLineMovePrev<CR>', { noremap=true, silent=true, })
vim.api.nvim_set_keymap('n', '<C-Right>', ':BufferLineMoveNext<CR>', { noremap=true, silent=true, })
