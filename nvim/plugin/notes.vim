function! _NotesFzf(query)
  let command_fmt = 'rg --sortr modified --column --no-heading --color=always --smart-case -- .+ || true'
  let spec = {'dir': $NOTES_DIR}
  call fzf#vim#grep(command_fmt, 1, fzf#vim#with_preview(spec), 1)
endfunction

command! -nargs=* -bang Notes call _NotesFzf(<q-args>)
