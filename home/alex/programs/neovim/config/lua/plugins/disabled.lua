return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  {
    "catppuccin/nvim",
    enabled = false,
  },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "folke/flash.nvim", enabled = false },
  {
    -- disable <Tab> and <C-i> default shortcuts
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    -- Conflict with git config
    "gbprod/yanky.nvim",
    keys = {
      {
        "<leader>gp",
        false,
      },
      {

        "<leader>gP",
        false,
      },
    },
  },
}
