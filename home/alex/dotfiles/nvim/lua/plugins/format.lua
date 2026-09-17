local formatters = {
  oxfmt = "oxfmt",
  prettier = "prettier",
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

-- Per-project formatter choice, resolved on every format: `stop_after_first`
-- runs only the first *available* entry, and the `require_cwd` overrides below
-- make each one available only in a project that actually configures it.
--   oxfmt config present      -> oxfmt
--   else prettier config      -> prettierd (falling back to prettier)
--   else                      -> nothing here; lsp_format takes over
local js_formatters = {
  formatters.oxfmt,
  formatters.prettier,
  stop_after_first = true,
}

local formatters_by_ft = {
  -- Not an oxfmt filetype: keep letting the astro LSP format it via lsp_format.
  astro = { formatters.prettier },
  javascript = js_formatters,
  typescript = js_formatters,
  javascriptreact = js_formatters,
  typescriptreact = js_formatters,
  css = js_formatters,
  html = js_formatters,
  json = js_formatters,
  jsonc = js_formatters,
  yaml = js_formatters,
  markdown = js_formatters,
  graphql = js_formatters,
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
    local util = require("conform.util")

    conform.setup({
      formatters_by_ft = formatters_by_ft,
      formatters = {
        oxfmt = {
          -- The builtin also accepts any `vite.config.{ts,js}` as an oxfmt root,
          -- which would hijack every Vite project that formats with prettier.
          -- Only a real oxfmt config counts as "this project uses oxfmt".
          cwd = util.root_file({
            ".oxfmtrc.json",
            ".oxfmtrc.jsonc",
            "oxfmt.config.ts",
          }),
          require_cwd = true,
        },
        -- Both look for .prettierrc*/prettier.config.* or a `prettier` key in
        -- package.json. Without require_cwd, the globally installed prettierd
        -- would claim every JS buffer and shadow oxfmt.
        prettierd = { require_cwd = true },
        prettier = { require_cwd = true },
      },
      -- Only reached for filetypes with no available formatter above. Note that
      -- it applies *every* attached client advertising documentFormattingProvider,
      -- so any filetype left to the fallback should only have one such server.
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 300,
      },
    })
  end,
}
