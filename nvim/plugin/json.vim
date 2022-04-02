augroup JSON
    function _JSONify()
        set filetype=json
        %!jq -S '.'
        normal zR
    endfunction

    command JSON call _JSONify()

    au BufNewFile,BufRead *.avsc set filetype=json
augroup END
