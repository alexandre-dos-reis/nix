local ensure_installed = {
  "html",
  "lua",
  "tsx",
  "typescript",
  "javascript",
  "prisma",
  "go",
  "templ",
  "astro",
  "cmake",
  "css",
  "scss",
  "fish",
  "gitignore",
  "markdown",
  "markdown_inline",
  "graphql",
  "http",
  "php",
  "rust",
  "sql",
  "nix",
  "just",
  "terraform",
  "nu",
  "zig",
  "cue",
  "c_sharp",
  "ruby",
}

return {
  {
    "windwp/nvim-ts-autotag",
    events = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_ft", { clear = true }),
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if not ok then
            return
          end
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })
    end,
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
}
