return {
  "akinsho/bufferline.nvim",
  lazy = false,
  priority = 1000,
  keys = {
    { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
  },
  opts = function()
    local theme = require("solarized-osaka.colors").setup()

    local selectedFg = theme.base0
    local terminalBg = vim.env.TERMINAL_BG

    -- This match the wallpaper color
    local topbarBg = "#002A36"
    -- local topbarBg = theme.base02

    local unselectedBg = theme.base03
    local unselectedFg = theme.base01
    local warningFg = theme.yellow
    local errorFg = theme.red
    local hintFg = theme.blue

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
          bg = terminalBg,
        },
        separator_visible = {
          fg = topbarBg,
          bg = unselectedBg,
        },
        separator = {
          fg = topbarBg,
          bg = unselectedBg,
        },
        tab = {
          bg = terminalBg,
        },
        tab_selected = {
          -- bold = true,
          bg = terminalBg,
        },
        buffer_selected = {
          fg = selectedFg,
          bg = terminalBg,
        },
        duplicate_selected = {
          italic = true,
          bold = true,
          fg = selectedFg,
          bg = terminalBg,
        },
        tab_separator = {
          fg = topbarBg,
          bg = unselectedBg,
        },
        tab_separator_selected = {
          fg = topbarBg,
          bg = terminalBg,
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
          -- bold = true,
        },
        warning_selected = {
          fg = warningFg,
          bg = terminalBg,
        },
        hint = {
          fg = hintFg,
          bg = unselectedBg,
        },
        hint_selected = {
          bg = terminalBg,
        },
        hint_diagnostic_selected = {
          bg = terminalBg,
        },
        info_selected = {
          bg = terminalBg,
        },
        error = {
          fg = errorFg,
          bg = unselectedBg,
          italic = true,
          -- bold = true,
        },
        warning_diagnostic_selected = {
          bg = terminalBg,
        },
        error_selected = {
          fg = errorFg,
          bg = terminalBg,
        },
        error_diagnostic_selected = {
          bg = terminalBg,
        },
        diagnostic_selected = {
          bg = terminalBg,
        },
        modified_selected = {
          bg = terminalBg,
        },
      },
    }
  end,
}
