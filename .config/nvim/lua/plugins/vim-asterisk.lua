local M = {}

M.config = function()
   -- Keep cursor position across matches
   vim.g['asterisk#keeppos'] = 1

   -- Search selected text.
   -- Smartcase as default behavior.
   -- z* motions doesn't move your cursor.
   local opts = {
     noremap=false,
     silent=false,
   }

   -- TODO: WhichKey-ify
   vim.api.nvim_set_keymap('n', '*' ,  '<Plug>(asterisk-*)', opts)
   vim.api.nvim_set_keymap('n', '#' ,  '<Plug>(asterisk-#)', opts)
   vim.api.nvim_set_keymap('n', 'g*' , '<Plug>(asterisk-g*)', opts)
   vim.api.nvim_set_keymap('n', 'g#' , '<Plug>(asterisk-g#)', opts)
   vim.api.nvim_set_keymap('n', 'z*' , '<Plug>(asterisk-z*)', opts)
   vim.api.nvim_set_keymap('n', 'gz*', '<Plug>(asterisk-gz*)', opts)
   vim.api.nvim_set_keymap('n', 'z#' , '<Plug>(asterisk-z#)', opts)
   vim.api.nvim_set_keymap('n', 'gz#', '<Plug>(asterisk-gz#)', opts)

   -- map *  <Plug>(asterisk-z*)
   -- map #  <Plug>(asterisk-z#)
   -- map g* <Plug>(asterisk-gz*)
   -- map g# <Plug>(asterisk-gz#)
end

return M
