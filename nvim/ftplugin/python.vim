set foldmethod=indent
nnoremap <leader>y :0,$!yapf<Cr><C-o>
let g:jedi#completions_enabled = 0
let g:jedi#usages_command = "<leader>N"

" causes jedi plugin noise
let PYTHONWARNINGS = ""
