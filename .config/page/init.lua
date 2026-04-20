--[[------------------------------------------------------------- overview ♠ ---

page config - https://github.com/I60R/page

- page spawns its own neovim instance using the settings in this file
- neovim's config ($XDG_CONFIG_HOME/nvim/init.lua) and plugins are not loaded
- this also means the only colorschemes available are neovim's built-in ones

the following patterns configure unique neovim buffers for each pager type:

+---------------------+------------+-------------------------+-----------------+
| pattern             | pager type | content                 | example         |
+---------------------+------------+-------------------------+-----------------+
| User PageOpenFile   | default    | files opened directly   | page file.txt   |
|                     |            | shell pager ($PAGER)    | less ABOUT.md   |
|                     |            |                         | more .zshrc     |
|---------------------+------------+-------------------------+-----------------+
| User PageOpen       | pipe       | stdin pipe              | cat a.md | less |
|                     |            | pty redirect            | ls > $(page -p) |
|                     |            | TODO: this redirects too| page            |
|                     |            | named instance          | page -i reuseme |
|---------------------+------------+-------------------------+-----------------+
| FileType man        | man        | man pages ($MANPAGER)   | man curl        |
+---------------------+------------+-------------------------+-----------------+

]]

----------------------------------------------------------- global options ♠ ---

-- these apply before any autocmd fires

vim.opt.scrolloff      = 999  -- keep cursor vertically centred while scrolling
vim.opt.sidescrolloff  = 999  -- keep cursor horizontally centred
vim.opt.relativenumber = true -- relative line numbers (useful for jump targeting)
vim.opt.cursorline     = true -- highlight the current line

------------------------------------------------------ pager type: default ♠ ---

-- triggered when page opens a file directly or receives input from the shell
-- pager (ie. less or more)
-- examples: page file.txt, more .gitignore, less README.md

vim.api.nvim_create_autocmd('User', {
    pattern  = 'PageOpenFile',
    callback = function()
        if vim.bo.filetype == 'man' then return end
        vim.cmd('colorscheme zaibatsu')
        vim.opt.wrap = true -- file content should wrap
    end,
})

--------------------------------------------------------- pager type: pipe ♠ ---

-- triggered when content arrives via stdin or redirect: eg. cmd | less
-- examples: cmd | less
--   page_icon_pipe     │  stdin pipe        cmd | less, PAGER, MANPAGER
--   page_icon_redirect ›  pty redirect      cmd > $(page -p)  (exposes a pty device)
--   page_icon_instance @  named instance    page -i name  (reusable buffer)

vim.api.nvim_create_autocmd('User', {
    pattern  = 'PageOpen',
    callback = function()
        if vim.bo.filetype == 'man' then return end
        vim.cmd('colorscheme habamax')
        vim.opt.wrap = false -- pipe output is often wide; scroll horizontally
    end,
})

---------------------------------------------------------- pager type: man ♠ ---

-- triggered by the -t man flag in MANPAGER
-- fires after PageOpen so its settings take precedence
-- man pages are structured prose, so optimising for that

vim.api.nvim_create_autocmd('FileType', {
    pattern  = 'man',
    callback = function()
        vim.cmd('colorscheme darkblue')
        vim.opt.relativenumber = false -- section headers matter more than line numbers
        vim.opt.wrap           = true  -- man pages are written to wrap
    end,
})

--------------------------------------------------------------- statusline ♠ ---

--- ♠ statusline icons ---------------------------------------------------------

-- page embeds these into the buffer name shown in the statusline

vim.g.page_icon_pipe     = '↦'
vim.g.page_icon_redirect = '↣'
vim.g.page_icon_instance = '#'

--- ♠ statusline config --------------------------------------------------------

-- uses neovim's built-in statusline format strings (:h statusline).
-- no custom highlight groups -- custom groups need re-applying after every
-- :colorscheme call (which fires per-buffer) and are not set at startup.
--
-- page buffer name formats:
--   pipe/redirect : {PAGE_BUFFER_NAME}"{icon}"
--   instance      : {instancename}"{icon}"{PAGE_BUFFER_NAME}
--   file/man://   : plain path or man://prog(N) URI
--
-- PageStatus() format: 📟 <name> · <type icon> <type> · <caller> · [flags]
--   pipe     📟 git log · ⋮ pipe · less · [RO]
--   instance 📟 testing · ∞ instance · page -i · [RO]
--   redirect 📟 ? · ⇢ redirect · $(page -p)
--   direct   📟 .zshrc · ◌ direct · less
--   man      📟 curl · ℹ man · [RO]
--
-- PAGE_PIPE_CMD (set by preexec in .zshrc): full typed command, eg. "git log | less"
-- used to extract the content source (before |) and pager caller (last segment)

_G.PageStatus            = function()
    local SEP      = ' · '
    local name     = vim.fn.bufname()
    local full_cmd = os.getenv('PAGE_PIPE_CMD') or ''

    -- first word of last pipe segment → the pager caller (eg. "less")
    local function get_pager(cmd)
        local last = vim.trim(cmd:match('[^|]*$') or '')
        return last:match('^%S+') or ''
    end

    -- [+] if modified, [RO] if readonly — nil if neither
    local function get_flags()
        local f = (vim.bo.modified and '[+]' or '') .. (vim.bo.readonly and '[RO]' or '')
        return f ~= '' and f or nil
    end

    -- join non-nil, non-empty varargs with SEP, append flags
    local function join(...)
        local t = {}
        for i = 1, select('#', ...) do
            local v = (select(i, ...))
            if v and v ~= '' then t[#t + 1] = v end
        end
        local fl = get_flags()
        if fl then t[#t + 1] = fl end
        return table.concat(t, SEP)
    end

    -- man:// URI (from man() shell function)
    local manpage = name:match('^man://(.*)')
    if manpage then return join('📟 ' .. manpage, 'ℹ man') end

    -- instance: {instancename}"{icon}"{PAGE_BUFFER_NAME} — name is before first quote
    local inst = name:match('^(.+)".-".+$')
    if inst then return join('📟 ' .. inst, '∞ instance', 'page -i') end

    -- pipe/redirect: {PAGE_BUFFER_NAME}"{icon}"
    local cmd_prefix, icon = name:match('^(.-)"(.-)"$')
    if icon == '↦' then
        local has_pipe = full_cmd:find('|', 1, true)
        local source   = has_pipe
            and vim.trim(full_cmd:match('^(.-)%s*|') or '')
            or (cmd_prefix ~= '' and cmd_prefix ~= 'page') and cmd_prefix
            or nil
        local pager    = get_pager(full_cmd)
        return join('📟 ' .. (source or '?'), '⋮ pipe', pager ~= '' and pager or nil)
    end
    if icon == '↣' then
        local source = (cmd_prefix ~= '' and cmd_prefix ~= 'page') and cmd_prefix or nil
        return join('📟 ' .. (source or '?'), '⇢ redirect', '$(page -p)')
    end

    -- plain file (PageOpenFile: less, more, page file)
    local filename = vim.fn.fnamemodify(name, ':t')
    local pager    = get_pager(full_cmd)
    return join('📟 ' .. filename, '◌ direct', pager ~= '' and pager or nil)
end

vim.opt.statusline       =
    ' %{v:lua.PageStatus()}' .. -- full status string with embedded flags
    '%=' ..                     -- right-align
    ' %l:%c ' ..                -- line:col
    ' %L ln ' ..                -- total lines
    ' %p%% '                    -- scroll %
