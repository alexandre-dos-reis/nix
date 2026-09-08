return {
  "craftzdog/solarized-osaka.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    on_highlights = function(hl, c)
      local bg_term = vim.env.TERMINAL_BG
      -- Blink
      hl.BlinkCmpMenu = {
        bg = bg_term,
        -- fg = bg_term,
      }
      hl.BlinkCmpMenuBorder = {
        bg = bg_term,
      }
      hl.BlinkCmpDoc = {
        bg = bg_term,
        -- fg = bg_term,
      }
      hl.BlinkCmpDocBorder = {
        bg = bg_term,
      }
      -- } Telescope and browser extension
      hl.TelescopeNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopeBorder = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopePromptNormal = {
        bg = c.bg_dark,
      }
      hl.TelescopePromptBorder = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopePromptTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopePreviewTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopeResultsTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      -- Lsp: hover and cmp
      hl.NormalFloat = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.FloatBorder = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.WhichKeyBorder = {
        bg = c.green700,
        fg = c.green500,
      }

      -- Remove bg color for error, warn, info and hint !
      for _, severity in ipairs({
        "DiagnosticVirtualTextError",
        "DiagnosticVirtualTextWarn",
        "DiagnosticVirtualTextInfo",
        "DiagnosticVirtualTextHint",
      }) do
        hl[severity] = nil
      end

      vim.opt.cursorline = true
      -- Cursor line
      hl.CursorLine = {
        bg = c.base03,
      }
      -- Cursor line number
      hl.CursorLineNr = {
        fg = c.base1,
        bold = true,
      }
    end,
  },
  config = function(_, opts)
    require("solarized-osaka").setup(opts)
    vim.cmd.colorscheme("solarized-osaka")
  end,
}
