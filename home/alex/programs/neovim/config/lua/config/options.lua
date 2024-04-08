-- oions are automatically loaded before lazy.nvim startup
-- Default oions that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional oions here

local o = vim.o

o.encoding = "utf-8"
o.number = true
o.fileencoding = "utf-8"

o.title = true
o.autoindent = true
o.smartindent = true
o.hlsearch = true
o.backup = false
o.showcmd = true
o.cmdheight = 1
o.laststatus = 0
o.expandtab = true
o.scrolloff = 10
o.relativenumber = true
o.shell = "fish"
o.clipboard = "unnamedplus"
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
o.foldenable = false

-- split windows
o.splitright = true
o.splitbelow = true
o.conceallevel = 1
