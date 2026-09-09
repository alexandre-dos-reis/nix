local formatters = {
  -- prettier = "prettier",
  stylua = "stylua",
  alejandra = "alejandra.toml",
  beautysh = "beautysh",
  rustfmt = "rustfmt",
  pg_format = "pg_format",
  terraform_fmt = "terraform_fmt",
  gofumpt = "gofumpt",
  golines = "golines",
  goimports_reviser = "goimports-reviser",
  php_cs_fixer = "php_cs_fixer",
}

local js_formatters = { formatters.prettier }

local formatters_by_ft = {
  astro = js_formatters,
  -- javascript = js_formatters,
  -- typescript = js_formatters,
  -- javascriptreact = js_formatters,
  -- typescriptreact = js_formatters,
  -- css = js_formatters,
  -- html = js_formatters,
  -- json = js_formatters,
  -- yaml = js_formatters,
  -- markdown = js_formatters,
  -- graphql = js_formatters,
  lua = { formatters.stylua },
  nix = { formatters.alejandra },
  go = {
    formatters.gofumpt,
    formatters.golines,
    formatters.goimports_reviser,
  },
  sh = { formatters.beautysh },
  rust = { formatters.rustfmt },
  sql = { formatters.pg_format },
  terraform = { formatters.terraform_fmt },
  php = { formatters.php_cs_fixer },
}

-- TODO: Implement this when new js formatters will became available like oxlfmt.
-- local resolve_formatters = function(buf, file) end

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre" },
  cmd = { "ConformInfo" },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = formatters_by_ft,
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 300,
      },
      format_after_save = {
        lsp_format = "fallback",
      },
    })
  end,
}
