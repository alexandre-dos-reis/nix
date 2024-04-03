-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.mapleader = " "

local k = vim.keymap
local opts = { noremap = true, silent = true }

-- Diagnostic
k.set("n", "<C-e>", vim.diagnostic.goto_next, opts)
k.set("n", "E", vim.diagnostic.goto_prev, opts)

-- recenter screen on page up and down
k.set("n", "<C-u>", "<C-u>zz")
k.set("n", "<C-d>", "<C-d>zz")

-- recenter screen on search
k.set("n", "n", "nzzzv")
k.set("n", "N", "Nzzzv")

-- dont yank when x is pressed
k.set("n", "x", '"_x')

-- Increment and decrement
k.set("n", "<leader>+", "<C-a>")
k.set("n", "<leader>-", "<C-x>")

-- move selection in visual mode
k.set("v", "J", ":m '>+1<CR>gv=gv")
k.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep yank in the buffer on paste
k.set("x", "<leader>p", '"_dP')

-- Managing tabs
k.set("n", "<leader>to", ":tabnew<CR>")
k.set("n", "<leader>tq", ":tabclose<CR>")
k.set("n", "<leader>tn", ":tabn<CR>")
k.set("n", "<leader>tp", ":tabp<CR>")

-- tmux-sessionizer
k.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
k.set("n", "<C-w>", "<cmd>silent !tmux neww tmux-windownizer<CR>")

-- https://www.reddit.com/r/neovim/comments/wi4uf3/how_do_i_insert_current_date_or_time/
k.set("n", "<leader>ct", ":pu=strftime('%Y-%m-%d')<CR>", { desc = "Get today's data in yy-mm-dd format." })
