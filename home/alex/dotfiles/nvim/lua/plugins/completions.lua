return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  opts = {
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "default",
      ["<C-i>"] = { "show" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      list = {
        selection = { preselect = true, auto_insert = false },
      },
      menu = { border = "rounded" },
      documentation = {
        window = { border = "rounded" },
        auto_show = true,
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { window = { border = "rounded" } },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      -- per_filetype = {
      --   sql = { "snippets", "dadbod", "buffer" },
      -- },
      providers = {
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
