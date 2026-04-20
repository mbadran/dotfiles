--[[----------------------------------------------------------- philosophy ♠ ---

1. improve vim, but kiss
    - key: vim is a human -> text interface, not an ide
    - make vim behave like a modern text editor without losing its essence
    - upgrade usability across three areas:
        1. extensions -- add what's clearly missing
        2. consistency -- align with modern conventions
        3. efficiency -- reduce friction and improve flow
2. be portable, with some concessions
    - use the defaults, by default
    - only configure things that are:
        - a) essential
        - b) compelling
    - minimise configs that behave differently in vanilla vim
    - limit config areas:
        - mappings -- <=20
        - plugins -- <=10
        - themes -- 1
        - everything else -- 0
            - ignore tabs, commands, functions, abbreviations, lsp, etc
            - use a graphical editor or ide, if necessary
3. go outdoors
    - use plugins passively (with defaults only or minimal options)
    - resist checking out other themes and plugins
    - avoid tweaking at all costs

]]

------------------------------------------------------------------ options ♠ ---

-- hide the intro message on startup [efficiency]
vim.opt.shortmess:append("I")

-- show relative line numbers [efficiency]
vim.opt.relativenumber = true

-- highlight the current line [efficiency]
vim.opt.cursorline = true

-- highlight column 80 for readability [efficiency]
vim.opt.colorcolumn = "80"

-- keep the cursor vertically and horizontally centered [efficiency]
vim.opt.scrolloff = 999
vim.opt.sidescrolloff = 999

-- wrap long lines at word boundaries [consistency]
vim.opt.linebreak = true

-- show wrap indicator [efficiency]
vim.opt.showbreak = "↪"

-- allow h/l and arrow keys to cross line boundaries [consistency]
vim.opt.whichwrap:append("<,>,h,l")

-- insert spaces instead of tabs [consistency]
vim.opt.expandtab = true

-- use single space after sentence joins [consistency]
vim.opt.joinspaces = false

-- treat < and > as matching pairs [extensions]
vim.opt.matchpairs:append("<:>")

-- ignore whitespace when diffing [efficiency]
vim.opt.diffopt:append("iwhite")

-- use case-insensitive search unless uppercase exists [efficiency]
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- open splits below and to the right [consistency]
vim.opt.splitbelow = true
vim.opt.splitright = true

-- persist undo history across sessions [extensions]
vim.opt.undofile = true

-- use the system clipboard for all yank and delete operations [consistency]
vim.opt.clipboard = "unnamedplus"

----------------------------------------------------------------- mappings ♠ ---

-- use space as the leader key [efficiency]
vim.g.mapleader = " "

--- ♠ visibility ---------------------------------------------------------------

-- show custom mappings [efficiency]
vim.keymap.set("n", "<leader>?", function()
    vim.cmd("filter /♠/ map")
end, { desc = "♠ show custom mappings" })

-- clear search highlights and messages [efficiency]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch|echo<CR>",
    { desc = "♠ clear highlights and messages" })

--- ♠ files & buffers ----------------------------------------------------------

-- toggle file explorer sidebar [consistency]
vim.keymap.set("n", "<C-b>", "<cmd>Lex 30<CR>",
    { desc = "♠ toggle file explorer" })

-- save buffer if modified [consistency]
vim.keymap.set("n", "<C-s>", "<cmd>up<CR>", { desc = "♠ save" })

-- close buffer [consistency]
vim.keymap.set("n", "<C-q>", "<cmd>bd<CR>", { desc = "♠ quit" })

-- fuzzy find files [extensions]
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>",
    { desc = "♠ find files" })

--- ♠ editing ------------------------------------------------------------------

-- join lines without moving the cursor [consistency]
vim.keymap.set("n", "J", "mzJ`z", { desc = "♠ join lines (no jump)" })

-- split line at the cursor, opposite of J [extensions]
vim.keymap.set("n", "K", "mzi<CR><Esc>`z", { desc = "♠ split line" })

-- paste from yank register, ignoring deletes [extensions]
vim.keymap.set("n", "<leader>p", [["0p]],
    { desc = "♠ paste from yank register" })

-- redo with U, symmetry with u [consistency]
vim.keymap.set("n", "U", "<C-r>", { desc = "♠ redo" })

-- repeat last substitution including flags [consistency]
vim.keymap.set("n", "&", "<cmd>&&<CR>", { desc = "♠ repeat substitution" })

-- keep selection after indent [consistency]
vim.keymap.set("v", "<", "<gv", { desc = "♠ indent left (keep selection)" })
vim.keymap.set("v", ">", ">gv", { desc = "♠ indent right (keep selection)" })

--- ♠ navigation ---------------------------------------------------------------

-- move by visual line, complements linebreak [consistency]
vim.keymap.set("n", "j", "gj", { desc = "♠ go down by visual line" })
vim.keymap.set("n", "k", "gk", { desc = "♠ go up by visual line" })

-- highlight word under cursor without jumping [consistency]
vim.keymap.set("n", "*", "mz*N`zzv", {
    silent = true,
    desc = "♠ highlight word (no jump)"
})
vim.keymap.set("n", "#", "mz#N`zzv", {
    silent = true,
    desc = "♠ highlight word in reverse (no jump)"
})

-- select last pasted text [extensions]
vim.keymap.set("n", "<leader>v", "`[v`]", { desc = "♠ select last paste" })

----------------------------------------------------------- plugin manager ♠ ---

-- bootstrap lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })
end

-- add lazy.nvim to runtime path (then run with :Lazy when needed)
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------------ plugins ♠ ---

require("lazy").setup({

    -- upgrade to a modern theme [efficiency]
    {
        "rebelot/kanagawa.nvim",
        priority = 1000, -- load first to avoid flicker
        config = function()
            require("kanagawa").setup({
                compile = true                     -- caches the theme for speed
            })
            vim.cmd.colorscheme("kanagawa-dragon") -- opts: wave*, dragon, lotus
        end
    },

    -- auto-detect indentation in files and set matching configs [consistency]
    -- (tabstop, shiftwidth, expandtab)
    {
        "tpope/vim-sleuth"
    },

    -- translate the statusline for humans [efficiency]
    {
        "nvim-lualine/lualine.nvim",
        opts = {}
    },

    -- show git diff indicators in the sign column [efficiency]
    {
        "lewis6991/gitsigns.nvim",
        opts = {}
    },

    -- show visual guides for indentation levels [efficiency]
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },

    -- enable fuzzy find for files, text, & more [extensions]
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    --[[
    add operators for editing surrounding characters [extensions]

    - new operators (sa, sd, sr) edit characters around motions and text objects

    1. sa{motion or text object}{char}       -- surround add
    2. sd{char}                              -- surround delete
    3. sr{char1}{char2}                      -- surround replace

    - important: these replace the s (substitute) operator, by default
    - examples:

    +-----+--------+------+-----+----------------------------+-----------------+
    | op  | target | char | sub | description                | meaning         +
    +-----+--------+------+-----+----------------------------|-----------------+
    | sa  | iw     | (    |     | surround add inside word ( | wrap word in () +
    | sd  |        | [    |     | surround delete [          | unwrap []       +
    | sr  |        | '    | "   | surround replace ' with "  | rewrap with "   +
    +-----+-------------+--------+--------+------------------+-----------------+

    -- ]]
    {
        "echasnovski/mini.surround",
        opts = {}
    },

    -- upgrade syntax highlighting and code understanding [extensions]
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install {
                'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim',
                'vimdoc', 'python', 'bash', 'json', 'yaml', 'toml'
            }
        end
    }

})
