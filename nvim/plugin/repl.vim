function _REPLAuto()
    if getbufinfo(1)[0].changed
        call _REPLRun()
    endif
endfunction

function _REPLRun()
    :update
    let repl_file = expand("%:p")
    wincmd p
    set nomodified
    let repl_cmd=g:repl_cmd . " '" . repl_file . "'"
    autocmd TermOpen * setlocal statusline=%{repl_cmd}
    call termopen(repl_cmd)
    normal! G
    wincmd p
endfunction

function _REPLInitInstant()
    autocmd TextChangedI * call _REPLAuto()
    autocmd TextChangedP * call _REPLAuto()
endfunction


function _REPLInit(...)
    let g:repl_cmd = a:1
    autocmd InsertLeave * call _REPLAuto()
    autocmd TextChanged * call _REPLAuto()
    autocmd BufDelete * :qa
    autocmd QuitPre * :qa
    set splitright
    vnew
    set nonu
    set nornu
    wincmd p
    call _REPLRun()
endfunction

command! -nargs=1 REPL call _REPLInit(<args>)
command! -nargs=1 REPLInstant call _REPLInit(<args>) | call _REPLInitInstant()
