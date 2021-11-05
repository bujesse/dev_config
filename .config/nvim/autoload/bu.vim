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
