" mbadran's gvimrc <github.com/mbadran/dotvim>

" settings {{{1

try
  set background=dark
  colorscheme solarized
catch /E185/
  " ok, use the default color scheme
endtry

" remove the toolbar
set guioptions-=T

" remove the left scrollbar when multiple vsplits present
set guioptions-=L

" tab settings
set guitablabel=%-3(%N\ %M%)%-100t
set guitabtooltip=%F\ (%n)

" never show the tab bar
" set showtabline=0

" macvim: settings {{{1

if has("gui_macvim")
  set macmeta

  " set guifont=Meslo\ LG\ S\ DZ:h13
  " set guifont=Meslo\ LG\ S\ DZ\ Regular\ for\ Powerline:h14
  set guifont=Menlo:h12

  " remove the right scrollbar for now (ugly in Lion)
  set guioptions-=r

  " TODO: add a bottom scrollbar (when/if Lion style scrollbars are introduced)
  " set guioptions+=b

  " macvim: mappings {{{1

  " nnoremap <D-1> 1gt
  " nnoremap <D-2> 2gt
  " nnoremap <D-3> 3gt
  " nnoremap <D-4> 4gt
  " nnoremap <D-5> 5gt
  " nnoremap <D-6> 6gt
  " nnoremap <D-7> 7gt
  " nnoremap <D-8> 8gt
  " nnoremap <D-9> 9gt

  " repurpose cmd-w to close the tab, and cmd-d to close the buffer
  " macmenu File.Close key=<D-d>
  " anoremenu <silent> .328 File.Close\ Tab :call <SID>CloseTab()<CR>
  " macmenu File.Close\ Tab key=<D-w>
  " macmenu File.Close\ Tab key=<D-d>

  " repurpose cmd-s to :update instead of saving every single time
  macmenu File.Save key=<nop>
  anoremenu <silent> .339 File.Update :call <SID>UpdateBuffer()<CR>
  macmenu File.Update key=<D-s>

  " open urls in the default browser
  nnoremap <silent> gb :silent !open <cWORD><CR>

  " map omnicomplete shortcuts (corresponding to their <c-x><c-?> letter
  " (:help ins-completion)
  " dictionary
  " inoremap <C-K> <C-X><C-K>
  " spelling
  " inoremap <C-S> <C-X><C-S>
  " tags
  " inoremap <C-]> <C-X><C-]>
  " file names
  " inoremap <C-F> <C-X><C-F>
  " vim/ex commands
  " inoremap <C-V> <C-X><C-V>
  " thesaurus (not configured)
  " inoremap <C-T> <C-X><C-T>
  " current and included files (unnecessary)
  " inoremap <C-I> <C-X><C-I>
  " definitions or macros (for c programs, unnecessary)
  " inoremap <C-D> <C-X><C-D>
  " user defined (none)
  " inoremap <C-U> <C-X><C-U>
  " omnicomplete (handled by supertab, overrides 'jump to normal mode')
  " inoremap <C-O> <C-X><C-O>
  " whole lines (broken)
  " inoremap <C-L> <C-L>
  " current file (handled by supertab, and <C-N> is already mapped to 'complete')
  " inoremap <C-N> <C-X><C-N>

  " sudo write for mac
  nnoremap <silent> <leader>W :SudoWriteMacGUI<CR>

" gvim {{{1

elseif (v:progname ==? "gvim")
  set guifont=Lucida_Console:h10:cANSI
  nnoremap <C-tab> gt
  nnoremap <C-S-tab> gT
endif

" mappings {{{1

" autocmds {{{1

" if the tabline is enabled, a new buffer is opened, and there are no splits,
" then this is probably a new tab. move it to the end. (NOTE: enew will
" trigger this action too, unfortunately)
autocmd BufNew * if &showtabline > 0 && winnr("$") == 1 | tabmove | endif

" function! s:CloseTab() " {{{1
"   try
"     tabclose!
"   catch
"     quit
"   endtry
" endfunction

function! s:UpdateBuffer() " {{{1
  " only save the buffer when there is something to save
  try
    update
  catch /E32/
    browse confirm saveas
  endtry
endfunction
