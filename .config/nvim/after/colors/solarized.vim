" TODO: tweak colours in the console.
" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
"
" > ./rgb2cterm 073642
" > 235

highlight NonText term=NONE gui=NONE guifg=#002b36 ctermfg=234
highlight SpecialKey term=NONE gui=NONE guifg=#002b36 ctermfg=234
" highlight Folded gui=bold
" highlight Folded guibg=#002b36 ctermbg=234
highlight Folded guibg=#002b36 ctermbg=NONE
" highlight SignColumn guibg=#073642 ctermbg=234 guifg=#ffffff ctermfg=white
highlight SignColumn guibg=#073642 ctermbg=NONE guifg=#ffffff ctermfg=grey
" highlight VertSplit guibg=#002b36 ctermbg=0 guifg=#839496 ctermfg=234
highlight VertSplit guibg=#002b36 cterm=NONE ctermbg=NONE guifg=#839496 ctermfg=NONE
" highlight VertSplit guibg=#002b36 ctermbg=234 guifg=#839496 ctermfg=234
" highlight VertSplit guibg=#002b36 ctermbg=grey guifg=#839496 ctermfg=grey
highlight CursorColumn guibg=#073642 ctermbg=234
highlight ColorColumn guibg=#073642 ctermbg=234

" autocmd InsertEnter * setlocal listchars-=trail:·
" autocmd InsertLeave * setlocal listchars+=trail:·
