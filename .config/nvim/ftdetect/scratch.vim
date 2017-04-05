" identify txt files with no extensions
" autocmd BufEnter * if &buftype ==# "nofile" && bufname("") != "VimFortune" | setlocal filetype=scratch | endif
" autocmd BufEnter * if &buftype ==# "nofile" && bufname("") !~# "\v^Vim(Fortune|bits).\*" | setlocal filetype=scratch | endif
" autocmd BufEnter * if &buftype ==# "nofile" && bufname("") !~# "^Vim" | setlocal filetype=scratch | endif
" TODO: fix and reenable this later

" make untyped files txt by default (annoying because it keeps txt filetype
" settings after the buffer type is changed)
" autocmd BufEnter * if empty(&filetype) | setlocal filetype=txt | endif
