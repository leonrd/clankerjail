" Local vimrc configuration {{{
let s:localrc = '~/.vimrc'
if filereadable(s:localrc)
    exec ':so ' . s:localrc
endif
" }}}