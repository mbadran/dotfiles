" settings {{{1

" setlocal statusline=\ %{GetDocTitle('Man')}%=[Man]\ %{expand('%:r')}%40P\ 
" setlocal statusline=\ %{GetDocTitle('Man')}%=[Man]\ %{expand('%:r')}%40P\ 
" setlocal nonumber norelativenumber statusline=\ %{GetDocTitle('Man')}%=[Man]\ %{expand('%:r')}%40(%)

" FIXME: i'd like to set this here, but it breaks the default setting in vimrc
" setlocal nonumber norelativenumber
