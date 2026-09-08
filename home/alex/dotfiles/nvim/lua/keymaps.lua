-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("utils").set_keymaps({
  -- Paste the clipboard content in Insert mode
  -- TODO: make this available in telescope
  { "i", "<C-v>", "<C-R>+" },
  -- kill highlight when escape press
  { "n", "<Esc>", "<Esc>:noh<CR>" },
  -- recenter screen on page up and down
  { "n", "<C-u>", "<C-u>zz" },
  { "n", "<C-d>", "<C-d>zz" },
  -- recenter screen on search
  { "n", "n", "nzzzv" },
  { "n", "N", "Nzzzv" },
  -- dont yank when x is pressed
  { "n", "x", '"_x' },
  -- Increment and decrement
  { "n", "<leader>+", "<C-a>", "Increment number" },
  { "n", "<leader>-", "<C-x>", "Decrement number" },
  -- move selection in visual mode
  { "v", "J", ":m '>+1<CR>gv=gv" },
  { "v", "K", ":m '<-2<CR>gv=gv" },
  -- move visual when indenting
  { "v", "<", "<gv" },
  { "v", ">", ">gv" },
  -- ep yank in the buffer on paste
  { "x", "<leader>p", '"_dP' },
  -- Managing tabs
  { "n", "<leader>to", ":tabnew<CR>" },
  { "n", "<leader>tq", ":tabclose<CR>" },
  { "n", "<leader>tn", ":tabn<CR>" },
  { "n", "<leader>tp", ":tabp<CR>" },
  -- Terminal related
  {
    "n",
    "<leader>tt",
    function()
      vim.cmd.vnew()
      vim.cmd.term()
      vim.cmd.wincmd("J")
      vim.api.nvim_win_set_height(0, 8)
      vim.cmd.startinsert()
    end,
  },
  {
    "t",
    "<esc><esc>",
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "bdelete!")
    end,
    "Close terminal",
  },
  -- tmux-sessionizer
  {
    "n",
    "<C-f>",
    "<cmd>silent !tmux neww tmux-sessionizer<CR>",
    "Launch tmux-sessionizer",
  },
  -- quicklist
  {
    "n",
    "<C-n>",
    function()
      if not pcall(vim.cmd.cnext) then
        vim.cmd.cfirst()
      end
    end,
    "Navigate to the next quickfix item",
  },
  {
    "n",
    "<C-p>",
    function()
      if not pcall(vim.cmd.cprev) then
        vim.cmd.clast()
      end
    end,
    "Navigate to the previous quickfix item",
  },
})
