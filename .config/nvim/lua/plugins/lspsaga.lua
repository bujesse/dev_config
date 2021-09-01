local saga = require 'lspsaga'

-- add your config value here
-- default value
-- use_saga_diagnostic_sign = true
-- error_sign = '',
-- warn_sign = '',
-- hint_sign = '',
-- infor_sign = '',
-- dianostic_header_icon = '   ',
-- code_action_icon = ' ',
-- code_action_prompt = {
--   enable = true,
--   sign = true,
--   sign_priority = 20,
--   virtual_text = true,
-- },
-- finder_definition_icon = '  ',
-- finder_reference_icon = '  ',
-- max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
-- finder_action_keys = {
--   open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
-- },
-- code_action_keys = {
--   quit = 'q',exec = '<CR>'
-- },
-- rename_action_keys = {
--   quit = '<C-c>',exec = '<CR>'  -- quit can be a table
-- },
-- definition_preview_icon = '  '
-- "single" "double" "round" "plus"
-- border_style = "single"
-- rename_prompt_prefix = '➤',
-- if you don't use nvim-lspconfig you must pass your server name and
-- the related filetypes into this table
-- like server_filetype_map = {metals = {'sbt', 'scala'}}
-- server_filetype_map = {}

saga.init_lsp_saga {
  border_style = 'round',
}

local opts = {
  noremap=true,
  silent=true,
}

vim.api.nvim_set_keymap('n', 'K', '<cmd>lua require"lspsaga.hover".render_hover_doc()<CR>', opts)
vim.api.nvim_set_keymap('i', '<C-_>', '<cmd>lua require"lspsaga.signaturehelp".signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-_>', '<cmd>lua require"lspsaga.signaturehelp".signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', 'ge', '<cmd>lua require"lspsaga.diagnostic".show_line_diagnostics()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>', opts)
-- vim.api.nvim_set_keymap('n', 'gh', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>lua require"lspsaga.action".smart_scroll_with_saga(1)<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<C-b>', '<cmd>lua require"lspsaga.action".smart_scroll_with_saga(-1)<CR>', opts)
-- vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua require"lspsaga.codeaction".code_action()<CR>', opts)
-- vim.api.nvim_set_keymap('v', 'gr', ':<C-U>lua require"lspsaga.codeaction".range_code_action()', opts)
-- vim.api.nvim_set_keymap('n', 'gR', '<cmd>lua require"lspsaga.rename".rename()<CR>', opts)

