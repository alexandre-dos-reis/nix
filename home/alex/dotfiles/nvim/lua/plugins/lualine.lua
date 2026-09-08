return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  -- enabled = false,
  opts = function()
    local colors = require("solarized-osaka.colors").setup()

    return {
      options = {
        globalstatus = true,
        theme = {
          normal = {
            a = { fg = colors.base1, bg = colors.base02, gui = "bold" },
            b = { fg = colors.base1, bg = colors.base03 },
            c = { fg = colors.base00, bg = vim.env.TERMINAL_BG },
          },
          insert = {
            a = { fg = colors.base03, bg = colors.warning, gui = "bold" },
          },
          visual = {
            a = { fg = colors.base03, bg = colors.magenta, gui = "bold" },
          },
          replace = {
            a = { fg = colors.base03, bg = colors.red, gui = "bold" },
          },
          inactive = {
            a = { fg = colors.base0, bg = colors.base02, gui = "bold" },
            b = { fg = colors.base03, bg = colors.base00 },
            c = { fg = colors.base01, bg = colors.base02 },
          },
        },
      },
      sections = {
        -- https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#filename-component-options
        lualine_c = {
          {
            "filename",
            -- Relative path
            path = 1,
          },
        },
      },
    }
  end,
}
