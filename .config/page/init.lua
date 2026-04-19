-- page init.lua
-- https://github.com/I60R/page
--
-- page spawns its own neovim instance using this file. your main
-- ~/.config/nvim/init.lua and its plugins are NOT loaded. only built-in
-- neovim colorschemes are available (habamax, zaibatsu, sorbet, etc.)
--
-- buffer patterns:
--   PageOpen     -- piped/redirected content  (cmd | less, PAGER)
--   PageOpenFile -- file opened directly       (page file.txt)
--   FileType man -- man page content           (triggered by -t man in MANPAGER)

-- ── global options ───────────────────────────────────────────────────────────────
-- use vim.opt (not vim.g) to set editor options -- vim.g sets neovim globals
-- (shell-like variables), not options. these apply before any autocmd fires.

vim.opt.scrolloff      = 999   -- keep cursor vertically centred while scrolling
vim.opt.sidescrolloff  = 999   -- keep cursor horizontally centred
vim.opt.relativenumber = true  -- relative line numbers (useful for jump targeting)
vim.opt.cursorline     = true  -- highlight the current line

-- ── statusline icons ─────────────────────────────────────────────────────────
-- page embeds these into the buffer name shown in the statusline.
-- choose distinct chars so you can tell at a glance how page was invoked:
--
--   page_icon_pipe     │  stdin pipe        cmd | less, PAGER, MANPAGER
--   page_icon_redirect ›  pty redirect      cmd > $(page -p)  (exposes a pty device)
--   page_icon_instance @  named instance    page -i name  (reusable buffer)
--
-- swap for nerd font glyphs if preferred, eg.  (terminal),  (arrow)

vim.g.page_icon_pipe     = '│'   -- vertical bar
vim.g.page_icon_redirect = '›'   -- single right angle
vim.g.page_icon_instance = '@'        -- at-sign (instance identifier)

-- ── statusline ────────────────────────────────────────────────────────────────────
-- custom statusline using catppuccin macchiato colours.
-- no plugins -- uses neovim's built-in statusline format strings (:h statusline).
-- highlight groups are re-applied via ColorScheme autocmd since :colorscheme
-- clears all custom highlights on load.
--
-- left:   [page label] [buffer name + icon] [flags]
-- right:  [line:col] [total lines] [scroll%]

local function setup_statusline_hl()
    local c = {
        base     = '#24273a',
        surface1 = '#494d64',
        text     = '#cad3f5',
        subtext0 = '#a5adcb',
        blue     = '#8aadf4',
        crust    = '#181926',
    }
    vim.api.nvim_set_hl(0, 'PageSLLabel', { bg = c.blue,     fg = c.crust,    bold = true })
    vim.api.nvim_set_hl(0, 'PageSLName',  { bg = c.surface1, fg = c.text })
    vim.api.nvim_set_hl(0, 'PageSLFill',  { bg = c.base,     fg = c.subtext0 })
    vim.api.nvim_set_hl(0, 'PageSLRight', { bg = c.surface1, fg = c.subtext0 })
end

-- re-apply after any :colorscheme call clears custom groups
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern  = '*',
    callback = setup_statusline_hl,
})

vim.opt.statusline =
    '%#PageSLLabel# page '   ..  -- label
    '%#PageSLName# %f %m%r ' ..  -- buffer name (with embedded icon), flags
    '%#PageSLFill#%='         ..  -- fill + right-align remainder
    '%#PageSLRight# %l:%c '  ..  -- line:col
    ' %L ln '                ..  -- total lines in buffer
    ' %p%% '                     -- scroll percentage

-- ── piped content ─────────────────────────────────────────────────────────────────
-- triggered when content arrives via stdin: cmd | less, PAGER invocations

vim.api.nvim_create_autocmd('User', {
    pattern  = 'PageOpen',
    callback = function()
        vim.cmd('colorscheme habamax')
        vim.opt.wrap = false  -- pipe output is often wide; scroll horizontally
    end,
})

-- ── file view ───────────────────────────────────────────────────────────────────────
-- triggered when page opens a file directly: page file.txt, page README.md

vim.api.nvim_create_autocmd('User', {
    pattern  = 'PageOpenFile',
    callback = function()
        vim.cmd('colorscheme zaibatsu')
        vim.opt.wrap = true  -- file content should wrap
    end,
})

-- ── man pages ──────────────────────────────────────────────────────────────────────
-- triggered by the -t man flag in MANPAGER, fires after PageOpen so its
-- settings take precedence. man pages are structured prose -- different needs.

vim.api.nvim_create_autocmd('FileType', {
    pattern  = 'man',
    callback = function()
        vim.cmd('colorscheme sorbet')
        vim.opt.relativenumber = false  -- section headers matter more than line numbers
        vim.opt.wrap           = true   -- man pages are written to wrap
    end,
})
