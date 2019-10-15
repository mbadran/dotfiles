" guidelines:
" 
" 1. kiss
" 2. don't set anything that would create confusion in vanilla vim/neovim
" 3. don't bother with plugins, mappings, commands, functions, or abbreviations

" hide the intro message on startup
set shortmess+=I

" set the theme
set background=dark
colorscheme desert

" show relative line numbers
set relativenumber

" underline the current line
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

" add angle brackets as a match pair
set matchpairs+=<:>

" ignore whitespace when diffing
set diffopt+=iwhite
