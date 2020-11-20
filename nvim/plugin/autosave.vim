let g:autosave_enabled = 0

function _AutoSave()
    if g:autosave_enabled
        :update
    endif
endfunction

autocmd InsertLeave * nested call _AutoSave()
autocmd TextChanged * nested call _AutoSave()

command EnableAutoSave :let g:autosave_enabled = 1
command DisableAutoSave :let g:autosave_enabled = 0
