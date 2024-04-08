return {
  "akinsho/bufferline.nvim",
  keys = {
    { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
  },
  opts = function()
    local c = require("solarized-osaka.colors").setup()

    local topbarBg = c.base02
    local unselectedBg = "#002933" -- Very close to base03
    local unselectedFg = c.base01
    local warningFg = c.yellow
    local errorFg = c.red
    -- local red = "#ff0000"

    -- https://github.com/akinsho/bufferline.nvim/blob/main/lua/bufferline/config.lua#L274
    return {
      options = {
        mode = "tabs",
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
      },
      highlights = {
        background = {
          fg = unselectedFg,
          bg = unselectedBg,
        },
        fill = {
          bg = topbarBg,
        },
        group_separator = {
          bg = topbarBg,
        },
        group_label = {
          fg = topbarBg,
          bg = unselectedBg,
        },
        separator_selected = {
          fg = topbarBg,
        },
        separator_visible = {
          fg = topbarBg,
          bg = unselectedBg,
        },
        separator = {
          fg = topbarBg,
          bg = unselectedBg,
        },
        tab_selected = {
          bold = true,
        },
        tab_separator = {
          fg = topbarBg,
          bg = unselectedBg,
        },
        tab_separator_selected = {
          fg = topbarBg,
        },
        offset_separator = {
          bg = topbarBg,
        },
        modified = {
          bg = unselectedBg,
        },
        duplicate = {
          bg = unselectedBg,
        },
        warning = {
          fg = warningFg,
          bg = unselectedBg,
          italic = true,
          bold = true,
        },
        warning_selected = {
          fg = warningFg,
        },
        error = {
          fg = errorFg,
          bg = unselectedBg,
          italic = true,
          bold = true,
        },
        error_selected = {
          fg = errorFg,
        },
      },
    }
  end,
}
