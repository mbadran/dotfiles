" i don't care for git tags, thanks
" FIXME: should work. doesn't work. doesn't matter.
" if has('autocmd')
"   augroup unfugitive
"     autocmd!
"     let g:all = split(&tags, ",")
"     echom("all")
"     let g:filtered = filter(g:all, "v:val !~ '/.git/'")
"     echom("filtered")
"     " echom(g:filtered)
"     let &l:tags = join(g:filtered, ",")
"     execute "setlocal tags=" . join(g:filtered, ",")
"     let g:watags = join(g:filtered, ",")
"     let &tags = g:watags
"     echom("tags")
"     echom(&tags)
"   augroup END
" endif
