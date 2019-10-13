" configuration guidelines:
"
" 1. kiss
" 2. don't use plugins, mappings, commands, functions, abbreviations
" 3. don't set anything that would create confusion with vanilla vim/neovim

" hide the intro message on startup
set shortmess+=I

" set the theme
set background=dark
colorscheme desert

" relative line numbers
set relativenumber

" highlight the line the cursor is on in the current buffer
set cursorline

" keep the cursor in the middle of the window
set scrolloff=999
set sidescrolloff=999

" wrap long lines
set linebreak

" show line wrap signs
set showbreak=↪

" let h and l traverse lines too
set whichwrap+=h,l

" enable case insensitive search when using lowercase letters
" set ignorecase

" enable case insensitive keyword completion when ignorecase is on
" set infercase

" insert spaces instead of tabs
set expandtab

" add only one space when joining sentences
set nojoinspaces

" match angle brackets too
set matchpairs+=<:>

" ignore whitespace for diff
set diffopt+=iwhite
