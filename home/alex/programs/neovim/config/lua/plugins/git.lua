return {
  {
    "dinhhuy258/git.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("git").setup({
        blame = "<Leader>gb",
        browse = "<Leader>go",
        open_pull_request = "<Leader>gp",
        diff = nil,
        diff_close = nil,
      })
    end,
  },
}
