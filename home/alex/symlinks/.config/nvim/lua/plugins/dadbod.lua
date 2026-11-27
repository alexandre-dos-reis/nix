return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    {
      "kristijanhusak/vim-dadbod-completion",
      ft = { "sql", "mysql", "plsql" },
      lazy = true,
    },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    local setPreviewHeight = "set previewheight="
      .. math.floor(vim.api.nvim_win_get_height(0) * 0.7)
    vim.cmd(setPreviewHeight)
  end,
  keys = {
    {
      "<leader>db",
      "<cmd>tabnew<cr><bar><bar><cmd>DBUI<cr>",
      desc = "Launch dadbod ui",
    },
  },
}
