return {
  "pablopunk/pi.nvim",
  event = "BufReadPre",
  keys = {
    { "<leader>ia", ":PiAsk<CR>", mode = { "n" }, desc = "Ask Pi about current buffer" },
    {
      "<leader>ia",
      ":PiAskSelection<CR>",
      mode = { "n" },
      desc = "Ask Pi about selection",
    },
  },
}
