require'lightspeed'.setup {
  jump_to_first_match = false,
  jump_on_partial_input_safety_timeout = 400,
  -- This can get _really_ slow if the window has a lot of content,
  -- turn it on only if your machine can always cope with it.
  highlight_unique_chars = false,
  grey_out_search_area = true,
  match_only_the_start_of_same_char_seqs = true,
  limit_ft_matches = 5,
  full_inclusive_prefix_key = '<c-x>',
  -- For instant-repeat, pressing the trigger key again (f/F/t/T)
  -- always works, but here you can specify additional keys too.
  instant_repeat_fwd_key = ';',
  instant_repeat_bwd_key = ',',
  -- By default, the values of these will be decided at runtime,
  -- based on `jump_to_first_match`.
  labels = {"f", "j", "d", "k", "s", "l", "a", ";", "e", "i", "w", "o", "g", "h", "v", "n", "c", "m", "z", "."},
  cycle_group_fwd_key = '<Tab>',
  cycle_group_bwd_key = '<S-Tab>',
}

-- Get back ; and , functionality to restart an f/t motion
function repeat_ft(reverse)
  local ls = require'lightspeed'
  ls.ft['instant-repeat?'] = true
  ls.ft:to(reverse, ls.ft['prev-t-like?'])
end
vim.api.nvim_set_keymap('n', ';', '<cmd>lua repeat_ft(false)<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', ';', '<cmd>lua repeat_ft(false)<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>,', '<cmd>lua repeat_ft(true)<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', '<Leader>,', '<cmd>lua repeat_ft(true)<cr>', {noremap = true, silent = true})

-- Don't execute Lightspeed f/t when recording macros
vim.api.nvim_set_keymap('n', 'f', 'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"', {expr = true})
vim.api.nvim_set_keymap('n', 'F', 'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"', {expr = true})
vim.api.nvim_set_keymap('n', 't', 'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"', {expr = true})
vim.api.nvim_set_keymap('n', 'T', 'reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"', {expr = true})
