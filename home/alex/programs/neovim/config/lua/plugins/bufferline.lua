return {
  "akinsho/bufferline.nvim",
  keys = {
    { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
  },
  opts = {
    options = {
      mode = "tabs",
      separator_style = "slant",
      show_buffer_close_icons = false,
      show_close_icon = false,
    },
    highlights = {
      separator = {
        fg = "#073642",
        bg = "#002b36",
      },
      separator_selected = {
        fg = "#073642",
      },
      background = {
        fg = "#657b83",
        bg = "#002b36",
      },
      fill = {

        bg = "#073642",
      },
      modified = {
        fg = "#F2A8AF",
      },
      modified_selected = {
        fg = "#F2A8AF",
      },
    },
  },
}
