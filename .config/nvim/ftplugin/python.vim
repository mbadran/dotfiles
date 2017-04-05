" settings {{{1

" unset _ as a word delimiter (this will allow jump-to-definition to work)
setlocal iskeyword+=_

" indentation {{{1

setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
" make backspace in indent mode treat 4 spaces like a tab
setlocal softtabstop=4

" abbreviations {{{1
inoreabbrev <buffer> ;;l % locals()
inoreabbrev <buffer> ;;b #! /usr/bin/env python
inoreabbrev <buffer> ;;i import 
inoreabbrev <buffer> ;;s self.

" TODO: reexamine these
"noreabbrev <expr> c resolve("%:p:h") . "/"
"inoreabbrev <expr> ;;k resolve("%:p:h") . "/"
"inoreabbrev <buffer> ;;l resolve("%:p:h") . "/"
"inoreabbrev <buffer> <expr> ;;m resolve("%:p:h") . "/"
"inoreabbrev <buffer> ;;n hello there
"iabbrev <expr> ;;o hi there
"inoreabbrev <script> ;;y gday there
"inoreabbrev <script> <buffer> ;;z yo there

" mappings {{{1
