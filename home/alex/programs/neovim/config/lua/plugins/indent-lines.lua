local symbol_char = "·"

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    main = "ibl",
    opts = function()
      local hooks = require("ibl.hooks")
      local theme = require("solarized-osaka.colors").setup()

      local color = theme.base02
      local highlightName = "IndentBlankline"

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, highlightName, { fg = color })
      end)

      local highlight = {
        highlightName,
      }

      return {
        indent = {
          tab_char = symbol_char,
          char = symbol_char,
          highlight = highlight,
        },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      }
    end,
  },
  {
    {
      "echasnovski/mini.indentscope",
      version = false, -- wait till new 0.7.0 release to put it back on semver
      event = "LazyFile",
      opts = function()
        local theme = require("solarized-osaka.colors").setup()

        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = theme.cyan500 })
        return {
          symbol = symbol_char,
          options = { try_as_border = true },
          draw = {
            delay = 0,
            -- https://github.com/echasnovski/mini.indentscope/blob/main/lua/mini/indentscope.lua#L181-L186
            -- stylua: ignore
            animation = function(_, _) return 10 end,
          },
        }
      end,
      init = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
          callback = function()
            ---@diagnostic disable-next-line: inject-field
            vim.b.miniindentscope_disable = true
          end,
        })
      end,
    },
  },
}
