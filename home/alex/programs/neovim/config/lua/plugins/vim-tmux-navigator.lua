return {
  "christoomey/vim-tmux-navigator",
  keys = {
    { "<C-k>", "<cmd>TmuxNavigateUp<cr><esc>", desc = "Move cursor to top pane" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr><esc>", desc = "Move cursor to bottom pane" },
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr><esc>", desc = "Move cursor to left pane" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr><esc>", desc = "Move cursor to right pane" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr><esc>", desc = "Move cursor to previous pane" },
  },
}
