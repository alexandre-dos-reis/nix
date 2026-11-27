return {
  "stevearc/quicker.nvim",
  ft = "qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
  keys = {
    {
      "<leader>qe",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      { desc = "Expand quickfix context" },
    },
    {
      "<leader>qc",
      function()
        require("quicker").collapse()
      end,
      { desc = "Collapse quickfix context" },
    },
  },
}
