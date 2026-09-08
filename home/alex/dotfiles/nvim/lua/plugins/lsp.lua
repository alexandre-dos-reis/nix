return {
  -- INFO: Default configuration for lsp servers.
  -- To override a configuration, create a file there:
  -- `after/lsp/[lsp_server_name].lua`
  "neovim/nvim-lspconfig",
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    cond = function()
      return vim.fn.executable("vscode-json-languageserver") == 1
        or vim.fn.executable("yaml-language-server") == 1
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
