-- oions are automatically loaded before lazy.nvim startup
-- Default oions that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional oions here

-- Enable undercurl for xterm-kitty -- NOT WORKING !
-- if vim.env.TERM == "xterm-kitty" then
--   vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
--   vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
-- end
--
-- -- Undercurl
-- vim.cmd([[let &t_Cs = "\e[4:3m"]])
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.wo.number = true

local o = vim.o

o.encoding = "utf-8"
o.fileencoding = "utf-8"

o.title = true
o.autoindent = true
o.smartindent = true
o.hlsearch = true
o.backup = false
o.showcmd = true
o.cmdheight = 1
o.laststatus = 2
o.expandtab = true
o.scrolloff = 10
o.relativenumber = true
o.shell = "fish"
-- o.backupskip = { "/tmp/*", "/private/tmp/*" }
o.inccommand = "split"
o.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
o.smarttab = true
o.breakindent = true
o.shiftwidth = 2
o.tabstop = 2
o.wrap = false -- No Wrap lines
-- o.backspace = { "start", "eol", "indent" }
o.swapfile = false

-- split windows
o.splitright = true
o.splitbelow = true
o.conceallevel = 1
