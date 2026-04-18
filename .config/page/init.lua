-- page init.lua
-- https://github.com/I60R/page

-- statusline icons
vim.g.page_icon_pipe     = ' » '   -- piped input (most common)
vim.g.page_icon_redirect = ' » '   -- exposes pty
vim.g.page_icon_instance = ' » '   -- named instance (-i/-I)

-- pager output buffers (piped/redirected content)
vim.api.nvim_create_autocmd('User', {
    pattern = 'PageOpen',
    callback = function()
        vim.cmd('colorscheme habamax')
        vim.opt.scrolloff = 999
        vim.opt.sidescrolloff = 999
        vim.opt.relativenumber = true
        vim.opt.cursorline = true
        vim.opt.wrap = false
    end,
})

-- file view buffers (page opened on a file, not piped)
vim.api.nvim_create_autocmd('User', {
    pattern = 'PageOpenFile',
    callback = function()
        vim.cmd('colorscheme retrobox')
        vim.opt.scrolloff = 999
        vim.opt.relativenumber = true
        vim.opt.cursorline = true
    end,
})
