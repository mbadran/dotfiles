autocmd BufEnter * call DetermineQuickfix()

function! DetermineQuickfix() " {{{1
  if &filetype == 'help' || &filetype == 'qf' || &filetype == 'man' || &filetype == 'gitcommit'
    if !exists('b:noquickfixsigns')
      let b:noquickfixsigns = 1
      call QuickfixsignsUpdate()
    endif
  endif
endfunction
