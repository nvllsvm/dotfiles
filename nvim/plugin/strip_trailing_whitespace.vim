function StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal! mz
    normal! Hmy
    %s/\s\+$//e
    normal! 'yz<CR>
    normal! `z
  endif
endfunction

command FixEmpty :set expandtab | :retab | call StripTrailingWhitespace() | :%s/\r//ge
