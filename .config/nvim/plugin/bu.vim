"   PERSONAL VIM GLOBALS


"   For wrapped lines, does gj/gk
"   For large jumps, adds a spot on the jump list
function! bu#jump_direction(letter)
  let jump_count = v:count

  if jump_count == 0
    call execute(printf('normal! g%s', a:letter))
    return
  endif

  if jump_count > 1
    call execute("normal! m'")
  endif

  call execute(printf('normal! %d%s', jump_count, a:letter))
endfunction

"   Move vertically until a non-whitespace character is found
function! bu#float_up(letter)
  call execute(printf('normal! g%s', a:letter))
  while line(".") > 1
        \ && (strlen(getline(".")) < col(".")
        \ || getline(".")[col(".") - 1] =~ '\s')
    call execute(printf('normal! g%s', a:letter))
  endwhile
endfunction

" Return list of acceptable 'rg' types for '-t' argument for filemask
function! bu#get_rg_type_list(ArgLead, CmdLine, CursorPos)
  let rg_types = split(system("rg -inHC 1 --type-list | sed 's/:.*//'"), '\n')
  return filter(rg_types, 'v:val =~ "^'. a:ArgLead .'"')
endfunction

function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

function! QuickFixToggle()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction
