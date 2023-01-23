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
   vim.api.nvim_set_keymap('', '#' ,  '<Plug>(asterisk-#)', opts)
   vim.api.nvim_set_keymap('', 'g*' , '<Plug>(asterisk-g*)', opts)
   vim.api.nvim_set_keymap('', 'g#' , '<Plug>(asterisk-g#)', opts)
   vim.api.nvim_set_keymap('', 'z*' , '<Plug>(asterisk-z*)', opts)
   vim.api.nvim_set_keymap('', 'gz*', '<Plug>(asterisk-gz*)', opts)
   vim.api.nvim_set_keymap('', 'z#' , '<Plug>(asterisk-z#)', opts)
   vim.api.nvim_set_keymap('', 'gz#', '<Plug>(asterisk-gz#)', opts)
   vim.api.nvim_set_keymap('', 'gz#', '<Plug>(asterisk-gz#)', opts)
end

return M
