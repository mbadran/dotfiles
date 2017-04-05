" mbadran's vimrc <github.com/mbadran/dotvim>

" bundles: boilerplate {{{1
set runtimepath+=$HOME/.vim/bundle/Vundle.vim/
try
  call vundle#rc()

  " bundles: github {{{1

  Bundle 'Glench/Vim-Jinja2-Syntax'
  Bundle 'Valloric/MatchTagAlways'
  Bundle 'VundleVim/Vundle.vim'
  Bundle 'altercation/vim-colors-solarized'
  Bundle 'avakhov/vim-yaml'
  Bundle 'bling/vim-airline'
  Bundle 'chreekat/vim-paren-crosshairs'
  Bundle 'csexton/trailertrash.vim'
  Bundle 'fatih/vim-go'
  Bundle 'gmarik/sudo-gui.vim'
  Bundle 'kana/vim-smartinput'
  Bundle 'majutsushi/tagbar'
  " Bundle 'mbadran/headlights'
  Bundle 'mbadran/jpythonfold.vim'
  " doesn't work well on the terminal
  " Bundle 'mhinz/vim-startify'
  Bundle 'nanotech/jellybeans.vim'
  Bundle 'nelstrom/vim-markdown-folding'
  Bundle 'rkitover/vimpager'
  " Bundle 'scrooloose/nerdtree'
  Bundle 'benekastah/neomake'
  " Bundle 'Shougo/deoplete.vim'
  Bundle 'sickill/vim-pasta'
  " Bundle 'sjl/gundo.vim'
  Bundle 'sukima/xmledit'
  Bundle 'takac/vim-hardtime'
  Bundle 'tomtom/quickfixsigns_vim'
  Bundle 'tomtom/tcomment_vim'
  " required by quickfixsigns
  Bundle 'tomtom/tlib_vim'
  Bundle 'tpope/vim-dispatch'
  Bundle 'tpope/vim-endwise'
  Bundle 'tpope/vim-eunuch'
  Bundle 'tpope/vim-fugitive'
  Bundle 'tpope/vim-markdown'
  Bundle 'tpope/vim-repeat'
  Bundle 'tpope/vim-scriptease'
  Bundle 'tpope/vim-sensible'
  Bundle 'tpope/vim-sleuth'
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-unimpaired'
  Bundle 'vim-ruby/vim-ruby'
  Bundle 'xolox/vim-misc'
  Bundle 'xolox/vim-easytags'

  " bundles: vim-scripts {{{1

  Bundle 'AfterColors.vim'
  Bundle 'CmdlineComplete'

catch /E117/ | endtry    " no vundle

" settings {{{1

" let g:mapleader = ','
let g:mapleader = ' '

" enable case insensitive search when using lowercase letters
set ignorecase

" enable case insensitive keyword completion when ignorecase is on
set infercase

" where possible, go to the first non-blank of the line instead of the start (eg. with gg and G)
set nostartofline

" ask for confirmation instead of failing commands
set confirm

" don't beep or flash
set visualbell
set t_vb=

" enable the mouse in all modes
set mouse=a

" time out quickly on mappings
set timeout
set timeoutlen=500

" allow modified buffers to be hidden
" set hidden

" highlight search matches
set hlsearch

" hide the intro message on startup
set shortmess+=I

" keep the cursor in the middle of the window
set scrolloff=999
set sidescrolloff=999

" put new :vsplits windows on the right
set splitright

" put new :split windows below
set splitbelow

" wrap long lines
set linebreak

" automatically save before certain commands
set autowriteall

" let h and l traverse lines too
set whichwrap+=h,l

" substitute all matches in a line instead of just the first (use /g flag for first match only)
set gdefault

" show line numbers
set number

if v:version > 702
  " show line numbers relative to the cursor position
  set relativenumber

  " change to dir of the current file automatically
  set autochdir
else
  " change to dir of the current file automatically
    lcd %:p:h
endif

" don't create swap files
set noswapfile

" enable backups
set backup

" allow persistent undos across sessions
set undofile

" save undo and backup files far away (and put the full dir path in the filename)
" (when the system restarts, undo files will be lost, which is OK
set undodir=$TEMP//,$TMP//,$TMPDIR//,/tmp/.
set backupdir=$TEMP//,$TMP//,$TMPDIR//,/tmp/.

" list all matches and complete till longest common string
" (tab twice to cycle through)
set wildmode=list:longest,list:full

" specify the language for spelling corrections
set spelllang=en_au

" specify a file for good spellings
set spellfile=$HOME/.vim/spell/general.utf-8.add

" specify the dictionary files for keyword completion
set dictionary+=/usr/share/dict/words

" specify the fill characters
set fillchars=vert:\\,fold:·

" add only one space when joining sentences
set nojoinspaces

" stop cursor from blinking in normal mode
set guicursor+=n:blinkon0

" limit the number of menu items for omnicomplete (temporary hack)
" temporarily disabled
" set pumheight=17

" allow the cursor to go anywhere in block mode
set virtualedit+=block

" show more information while completing tags
set showfulltag

" always report number of lines changed
" setting to 1 for now -- too much noise
set report=1

" match angle brackets too
set matchpairs+=<:>

" don't make windows the same size
set noequalalways

" speed up background operations
set updatetime=1000

" unset these as word delimiters
set iskeyword+=$,%,#

" set these as word delimiters
set iskeyword-=_

" set grep options
" TODO: review ack vs grep vs ag
" set grepprg=ack\ -H\ --nocolor\ --nogroup\ --column
" set grepformat=%f:%l:%c:%m,%f:%l%c%m,%f %l%c%m
" set grepformat=%f:%l:%c:%m

" use custom text for folds
set foldtext=MyFoldText()

" ignore files with these extensions when completing filenames
set suffixes+=.pdf

" ignore whitespace for diff
set diffopt+=iwhite

" make quickfix (and :sb* commands) switch to open windows and tabs
" (this breaks :sbuffer -- use :vsp and :spl instead)
set switchbuf=useopen,usetab
" make quickfix open new tabs (splits in <v7) instead of reusing the window
set switchbuf+=split,newtab

" better line wrap signs
set showbreak=↪

" don't show the mode (airline has got this handled)
set noshowmode

" give more space for messages
set cmdheight=2

" indentation {{{1

" insert spaces instead of tabs
set expandtab

" autocmds {{{1

if has("autocmd")
  augroup vimrc
    " reset all autocmds for quick re-sourcing
    autocmd!

    " configure command line buffers
    autocmd FileType * if bufname("") ==? "[Command Line]" | setlocal nonumber norelativenumber | endif

    " automatically close the preview window
    autocmd CursorMovedI,InsertLeave * if !pumvisible() | silent! pclose | endif

    " open files at the last position
    autocmd BufReadPost * call <SID>GoToLastPosition()

    " automatically source vimrc and gvimrc upon saving
    " (allow nested autocommands)
    autocmd BufWritePost vimrc,gvimrc nested source %

    " resize splits when the window is resized
    autocmd VimResized * wincmd =

    " highlight the line the cursor is on in the current buffer
    if has("gui_running")
      autocmd BufEnter,InsertLeave * setlocal cursorline
      autocmd BufLeave,InsertEnter * setlocal nocursorline
    endif

    " don't change the cursorline for startify windows
    autocmd FileType startify setlocal nocursorline
  augroup END
endif

" mappings: all {{{1

" swap mark commands
noremap ' `
noremap ` '

" swap the default movements on wrapped lines
" side effect: operator-pending movements behave differently on unwrapped lines
" use dgj and dgk instead of the handy dj and dk (annoying but consistent)
" this is bad to ingrain into muscle memory, gets confusing when using vanilla vim
noremap j gj
noremap k gk
noremap 0 g0
noremap $ g$
noremap gj j
noremap gk k
noremap g0 0
noremap g$ $

" make searches 'very magic' by default
noremap / /\v
noremap ? ?\v

" power search with the commandline window
" also, filetype workaround (no idea why autocmds don't apply to the q/ and q? windows)
noremap <silent> <leader>/ q/:setlocal filetype=vim nonumber norelativenumber<CR>i\v
noremap <silent> <leader>? q?:setlocal filetype=vim nonumber norelativenumber<CR>i\v

" mappings: normal {{{1

" toggle folds more easily
nnoremap <CR> za
nnoremap <silent> <S-CR> :silent call <SID>ToggleAllFolds()<CR>
nnoremap <silent> <C-CR> zMzv

" overload Esc to also clear search matches
nnoremap <silent> <Esc> <Esc>:nohlsearch<CR>

" simplify window movements
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" repeat the last macro quickly
" nnoremap <leader>. @@

" use <Tab> for % matching and <C-p> for jumping forwards
" (because <Tab> and <C-i> are the same as far as Vim is concerned)
" nnoremap <C-p> <Tab>
" vnoremap <C-p> <Tab>

" now, we can use <Tab> to jump between matches
" nnoremap <Tab> %
" vnoremap <Tab> %

" nnoremap <BS> %

" unwindows
nnoremap <silent> <leader>ew :%s/\r//e<Bar>set fileformat=unix<CR>

" txtify
nnoremap <leader>ex :setlocal filetype=txt<CR>

" follow the symlinks so we can check in changes
nnoremap <silent> <leader>ev :execute "edit " . resolve($MYVIMRC)<CR>
nnoremap <silent> <leader>eg :execute "edit " . resolve($MYGVIMRC)<CR>

nnoremap <silent> <leader>eh :edit /etc/hosts<CR>
nnoremap <silent> <leader>et :edit $HOME/.tmux.conf<CR>
nnoremap <silent> <leader>ec :edit $HOME/.ssh/config<CR>

nnoremap <silent> <leader>es :update<Bar>source %<CR>

nnoremap <silent> <leader>c :call <SID>ToggleColorColumn()<CR>

nnoremap <silent> <leader>l :call <SID>ToggleListChars()<CR>

nnoremap <leader>h :help<SPACE>

" don't use ex mode, do formatting instead
nnoremap Q gqip
vnoremap Q gq

" reselect text that was just pasted
nnoremap <leader>v V`]

" don't move on matches
nnoremap * *<C-o>
nnoremap # #<C-o>

" show only the current buffer
nnoremap <silent> <leader><TAB> :silent only<CR>

" fast make
nnoremap <silent> <leader>m :make<CR>

" enter virtual replace mode by default, handy for replacing an identical number of chars
nnoremap R gR

" jump to the tag in a new horizontal split
nnoremap <C-\> <C-w><C-]>

" jump to the previous tag in the stack (opposite of C-])
nnoremap <A-]> :pop<CR>

" keep the cursor in place while joining lines
" NOTE: this overwrites the Z mark (a function can be used to remember the cursor instead)
nnoremap <silent> J mZJ`Z:delmark Z<CR>

" copy the current filename to the clipboard
nnoremap <leader>F let @* = expand("%:p")

" map splits
nnoremap <leader>s :split<CR>
nnoremap <leader>v :vsplit<CR>

" update (write) buffer
nnoremap <silent> <leader>w :update<CR>

" close buffer
" nnoremap <silent> <leader>c :close<CR>

" quit buffer
nnoremap <silent> <leader>q :quit<CR>

" edit a new buffer
nnoremap <silent> <leader>n :enew<CR>

" convert buffer to a scratch file (if you don't care about saving it)
nnoremap <silent> <leader>S :setlocal buftype=nofile bufhidden=hide<CR>

" automatically correct the spelling to the first option
" NOTE: z= shows the spelling correction menu, [s and ]s navigate misspellings
nnoremap <leader>z 1z=

" show the omnicomplete spelling menu
" TODO: investigate using neocomplcache for spelling corrections
nnoremap <leader>Z ea<C-X><C-S>

" FIXME, can't get FIXME to work
" TODO: consider making a very lightweight plugin for this (and grep, and
" locate, and find, and last search, and new search, and help, etc. but keep
" it very lightweight with just a few options, but all configurable)
" nnoremap <leader>d :vimgrep /TODO\|FIXME/j %<BAR>:cwindow<CR>
nnoremap <silent> <leader>d :vimgrep /TODO/j %<BAR>:botright cwindow 20<CR>:wincmd k<CR>

" mappings: visual {{{1

" reselect after an indent action (to facilitate repeat actions)
vnoremap > >gv
vnoremap < <gv

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><C-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><C-o>

" mappings: command {{{1

" emacs bindings in command line mode
cnoremap <C-a> <home>
cnoremap <C-e> <end>

" do a sudo write
" cnoremap w!! w !sudo tee % > /dev/null
" cnoremap w!! SudoWriteMacGUI

" fix searches
cnoremap %s/ %s/\v
cnoremap %g/ %g/\v

cnoremap <expr> ;;p expand("%:p:h") . "/"

" mappings: insert {{{1

" calculate expression
inoremap <C-B> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

" mappings: operator-pending {{{1

" abbreviations {{{1

" silence grep, let the quickfix window show results
cabbrev grep silent grep

" commands {{{1

command! DiffOrig vertical new | set buftype=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" terminal {{{1

if !has("gui_running")
  " plugins should be disabled

  " set the terminal to 256 colors
  set t_Co=256

  colorscheme jellybeans

  " don't highlight the current line
  set nocursorline

  " set the terminal's title to the filename
  set title

  " enable the menu (for headlights and otherwise)
  runtime! menu.vim
  set wildmenu
  set cpoptions-=<
  set wildcharm=<C-Z>
  map <leader><SPACE> :emenu <C-Z>
endif

" plugin: runtime {{{1

runtime! ftplugin/man.vim

" plugin: headlights {{{1

" let g:headlights_use_plugin_menu = 1
" let g:headlights_debug_mode = 1
let g:headlights_show_files = 1
" let g:headlights_show_load_order = 1
" let g:headlights_show_commands = 0
" let g:headlights_show_mappings = 0
let g:headlights_show_abbreviations = 1
let g:headlights_show_functions = 1
" let g:headlights_smart_menus = 0
let g:headlights_show_highlights = 1
" let g:headlights_unprefix_names = 0
" let g:headlights_run_on_startup = 1
" let g:headlights_spillover_menus = 1

" plugin: syntastic {{{1

let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
" all python syntax errors are reported as warnings, for some reason. bad.
" let g:syntastic_quiet_warnings = 1

" plugin: tagbar {{{1

let g:tagbar_left = 1
let g:tagbar_compact = 1
" let g:tagbar_width = 31
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_ctags_bin = "/usr/local/bin/ctags"

nnoremap <silent> <leader>t :TagbarToggle<CR>

" plugin: quickfixsigns {{{1

" don't show quickfixsigns for special buffers like tagbar, unite, and anything starting with [
" FIXME: find a way to disable signs column for scratch/preview buffers without
" also disabling it for new (unnamed) vim buffers
let g:quickfixsigns_blacklist_buffer = '^__.*__\|^$\|ControlP\|^NetrwTreeListing\|\[.*$'
let g:quickfixsigns#marks#texthl = "SignColumn"
let g:quickfixsigns_icons = {}

" plugin: easytags {{{1

let g:easytags_cmd = "/usr/local/bin/ctags"
let g:easytags_updatetime_warn = 0

" plugin: airline {{{1

" use fancy unicode symbols
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_left_alt_sep = '·'
let g:airline_right_alt_sep = '·'
" let g:airline_linecolumn_prefix = '␊'
" let g:airline_linecolumn_prefix = '␤'
" let g:airline_linecolumn_prefix = '¶'
" " let g:airline_linecolumn_prefix = ''
" " let g:airline_linecolumn_prefix = '⭡'
" let g:airline_symbols.branch = '⎇ '
" let g:airline_symbols.paste = 'Þ'
let g:airline_whitespace_symbol = 'Ξ'
" " let g:airline_readonly_symbol = '⭤'
" let g:airline_readonly_symbol = ''

" show buffer and tab titles
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" replace branch with current dir (may differ from file dir)
let g:airline_section_b = "%{getcwd()}"
let g:airline_section_c = "%t"

" replace readonly with readonly, non-unix ff, and non-utf-8 fenc
let g:airline_section_gutter = " %#airline_file#%{airline#util#wrap(airline#parts#readonly(),0)}%{&fileformat=='unix'?'':&fileformat}%{&fileencoding=='utf-8'?'':'   '.&fileencoding}%="

" replace fenc and ff with branch
let g:airline_section_y = "%{airline#extensions#branch#get_head()}"

" shuffle line position details and use virtual columns
" let g:airline_section_z = "%3p%% %3v %3l"
" let g:airline_section_z = "%3p%% %{g:airline_symbols.linenr} %3l:%3c"
" let g:airline_section_z = "%3p%% %{g:airline_symbols.linenr} %3c %{g:airline_symbols.linenr} %3l"
" let g:airline_section_z = "%3p%% %3c %{g:airline_symbols.linenr} %3l"
" let g:airline_section_z = "%3p%% %3v %{g:airline_symbols.linenr} %3l"
" let g:airline_section_z = "%3p%% %{g:airline_right_alt_sep} %3v %{g:airline_right_alt_sep} %3l"
" let g:airline_section_z = "%3p%% %3v %{g:airline_right_alt_sep} %3l"

" plugin: solarized {{{1

let g:solarized_menu = 0

" plugin: neocomplcache {{{1
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_source_disable = {"dictionary_complete": 1}

" use tab and shift-tab for completion
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" close the popup when backspacing a character
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"

" plugin: fugitive {{{1
nnoremap <leader>gg :Git<SPACE>
nnoremap <silent> <leader>gc :Gcommit %<CR>
nnoremap <silent> <leader>gC :Gcommit<CR>
nnoremap <silent> <leader>gp :Git push<BAR>silent only<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gD :silent only<BAR>:diffoff<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>

" plugin: quicktrix {{{1
" let g:quicktrix_orientation = "bottom"
" let g:quicktrix_steal_focus = 0

" nnoremap <silent> <leader>d :QTodo<CR>
" " nnoremap <leader>g :QGrep<SPACE>
" " nnoremap <leader>f :QFind<SPACE>
" " nnoremap <leader>l :QLocate<SPACE>
" " nnoremap <leader>H :QHelp<SPACE>
" nnoremap <silent> <leader>g :QGrep<CR>
" nnoremap <silent> <leader>f :QFind<CR>
" nnoremap <silent> <leader>e :QLocate<CR>
" nnoremap <silent> <leader>H :QHelp<CR>

" plugin: jpythonfold {{{1

" let g:jpythonfold_CustomFoldText = 1
" let g:jpythonfold_Compact = 1

" plugin: ctrlp {{{1

let g:ctrlp_switch_buffer = "ETVH"
let g:ctrlp_max_height = 25
" only for creating new files
" let g:ctrlp_open_new_file = 't'
" open all files in new tabs
let g:ctrlp_open_multiple_files = 'tj'
" don't prompt for options when opening tabs
let g:ctrlp_arg_map = 0
" reset mru files
let g:ctrlp_mruf_max = 25
let g:ctrlp_mruf_exclude = '.*vimrc\|.*/vim/runtime/doc.*\|/private/var/.*'

nnoremap <silent> <C-Space> :CtrlPMRUFiles<CR>
nnoremap <silent> <S-Space> :CtrlPBuffer<CR>
nnoremap <silent> <leader>r :CtrlPRegister<CR>

" plugin: nerdtree {{{1

let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeQuitOnOpen = 1

nnoremap <silent> <leader><leader> :call <SID>ToggleNERDTreeCWD()<CR>

" plugin: tcomment {{{1

nmap <leader>c gcc
vmap <leader>c gc
nmap <leader>C gc

" plugin: startify {{{1

" show a custom header
let g:startify_custom_footer = [ '', '   ' . strftime('%A, %d %B, %X') ]

let g:startify_bookmarks = [ "~/Google\ Drive/projects/hda/request_scripts/search.php", "~/Google\ Drive/projects/hda/request_scripts", "~/Google\ Drive/projects/hda/", "~/Google\ Drive/projects/", "~/Documents/", "~/Desktop/" ]
let g:startify_custom_indices = [ "a", "d", "f", "g", "h", "j", "k", "l", ";", "w", "r", "y", "u", "o", "p", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
let g:startify_list_order = [ 'bookmarks', 'sessions', 'files' ]
let g:startify_files_number = 19
let g:startify_enable_special = 0
let g:startify_skiplist = [
  \ $MYVIMRC,
  \ $HOME . '/.vim/gvimrc',
  \ 'COMMIT_EDITMSG',
  \ $VIMRUNTIME . '/doc',
  \ 'bundle/.*/doc',
  \ '/private/etc/hosts',
  \ $HOME . '/.ssh/config',
  \ '.*/.git/index',
  \ '\.DS_Store'
  \ ]

" plugin: hardtime {{{1

let g:hardtime_default_on = 1

let g:list_of_visual_keys = [ "h", "j", "k", "l",
                 \ "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]

let g:list_of_normal_keys = [ "h", "j", "k", "l",
                 \ "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]

function! s:ToggleNERDTreeCWD() " {{{1
  " because NERDTreeToggle doesn't change the cwd if NERDTree is open
  if exists("g:NERDTree_opened")
    execute "NERDTreeClose"
    unlet g:NERDTree_opened
  else
    execute "NERDTree"
    let g:NERDTree_opened = 1
  endif
endfunction

function! s:GoToLastPosition() " {{{1
  if line("'\"") > 0 && line("'\"") <= line("$")
    execute "normal! g`\""
  endif
endfunction

function! s:ToggleAllFolds() " {{{1
  if !&foldlevel
    setlocal foldlevel=99
  else
    setlocal foldlevel=0
  endif
endfunction

function! s:ToggleColorColumn() " {{{1
  " disable, if set. otherwise, show colorcolumn at 'textwidth', or at 81 chars by default
  if &colorcolumn
    let &l:colorcolumn = ""
  else
    if &textwidth
      let &l:colorcolumn = &textwidth + 1
    else
      let &l:colorcolumn = 81
    endif
  endif
endfunction

function! s:IsSpecialBuffer() " {{{1
  if &filetype ==? "tagbar" || &filetype ==? "nerdtree" || &filetype ==? "help" || &filetype ==? "qf" || &filetype ==? "man" || &filetype ==? "gitcommit" || &filetype ==? "preview" || &filetype ==? "unite" || bufname("") ==? "[Command Line]" || &buftype ==? "nofile"
    return 1
  endif
  return 0
endfunction

function! s:ToggleListChars() " {{{1
  " optimised for solarized
  " hide tildes by default, allow toggle for special chars
  " TODO: convert this into a plugin that takes the highlight commands as input
  " and then just call it from here (or any other colorscheme 'after' scripts)
  " ,c for [list/special] characters
  if exists('w:ListChars')
    highlight NonText guifg=#002b36 ctermfg=234 guibg=#002b36 ctermbg=NONE
    highlight SpecialKey guifg=#002b36 ctermfg=234 guibg=#002b36 ctermbg=NONE
    set nolist
    unlet w:ListChars
  else
    let w:ListChars = 1
    highlight Nontext guifg=#ffffff ctermfg=red guibg=#002b36 ctermbg=NONE
    highlight SpecialKey guifg=#ffffff ctermfg=red guibg=#002b36 ctermbg=NONE
    set list
  endif
endfun

function! s:VSetSearch() " {{{1
  " Visual Mode */# from Scrooloose
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

function! MyFoldText() " {{{1
  " so far, handles vim and python well. TODO: test folding with other languages.
  " hides number of folded lines and strips other unnecessary metadata
  let line = getline(v:foldstart)
  " let text = substitute(line, '\v^\s*"|^def |^function!? |"?\s*\{\{\{\d|:$', '', 'g')
  " let text = substitute(line, '\v^\s*"|^def |^function\zs!\ze? |"?\s*\{\{\{\d|:$', '', 'g')
  let text = substitute(line, '\v^\s*"|^def |"?\s*\{\{\{\d|:$', '', 'g')
  return "+-- " . substitute(text, '\v^\s+|\s+$', '', 'g') . " "
endfunction

" cheatsheet {{{1

" profiling vim
" # vim --startuptime vim.log

" '. goes to previously edited line
" `. goes to previous column on previously edited line
" gi goes to previous column on previously edited line, putting you in insert
" mode.

" ctrl-w ] will open the tag/function/method in a split -- better than jumping
" back and forth, especially when you still want to see the invoking code

" select the just pasted text: V`]

" %s/pattern//gn number of occurrences of pattern

" ex commands: g/setlocal/ normal I"
" http://blog.sanctum.geek.nz/using-more-of-ex/

" http://henrik.nyh.se/2011/01/textmate-to-vim-with-training-wheels
" 80i-<Esc>
" YpVr=
" das
" dis
" cas
" cis
" d(
" d2(

" f<char> -> then -> c; or c, to d; d, to delete to that line operation mark

" gP pastes the text before the current char, and leaves the cursor on the
" current char. whereas P pastes the text before the current char, and moves
" the cursor to the end of the pasted text (one to the left of the previous
" char)

" g_ is to $ what ^ is to 0

" g`" goes to the last cursor position in the file

" gv - repeat the last selection

" learn more about the :g command -- for example, to do actions or run script
" snippets on specific lines, the same way you used to with beanshell. see
" also the tip about using the /norm ex command with :g to run normal mode
" commands on specific lines (for eg. :g/^\d/norm A; -- this appends a
" semicolon to lines starting with numbers.) the great thing is that this
" works with any ex command, so you can run sophisticated commands on lines

" to paste the value of a variable/expression in insert mode, do the
" following: <C-r>=&tags -- this saves you having to type values manually, and
" is very handy, especially when you consider that you can put local settings
" (&l:), any global vars (with completion!), any custom expressions, maths --
" whatever.

" ]p to paste with indentation

" gqq reformats the current line

" ci(” can be replaced with “cib”
" ci{” can be replaced with “ciB”
" cit for tags

" q: — Open with a command history from normal mode
" q/ — Open with a search history from normal mode (to seach forward)
" q? — Open with a search history from normal mode (to seach backward)
" Ctrl+F — Open with a command history from command mode

" gu<motion> -- lowercase
" gU<motion> -- UPPERCASE

" :map <keys> -- find the mapping corresponding to <keys>

" folding
"za toggles a fold opened and closed!
"zf#j  creates a fold from the cursor down  #  lines.
"zf/string creates a fold from the cursor to string .
"zj moves the cursor to the next fold.
"zk moves the cursor to the previous fold.
"zo opens a fold at the cursor.
"zO opens all folds at the cursor.
"zm increases the foldlevel by one.
"zM closes all open folds.
"zr decreases the foldlevel by one.
"zR decreases the foldlevel to zero -- all folds will be open.
"zd deletes the fold at the cursor.
"zE deletes all folds.
"[z move to start of open fold.
"]z move to end of open fold.

" vim -N -u NONE -U NONE
" for debugging, this command will let you call vim in nocompatible mode, with
" no vimrc and no gvimrc settings then you can source ~/.vimrc and check that
" everything works in a cross platform way

" <C-y> closes an omnicomplete menu
" <C-e> cancels an omnicomplete menu and reverts any changes

" use CTRL_R " to paste the contents of the unnamed register (or any other
" register) into the command line. these mappings work with insert mode too,
" but i tend to just use command mode for pastes.
