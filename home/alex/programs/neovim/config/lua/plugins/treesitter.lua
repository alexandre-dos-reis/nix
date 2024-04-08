return {
  "nvim-treesitter/nvim-treesitter",
  dev = true,
  opts = {
    highlight = {
      enable = true,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    -- Mdx
    vim.filetype.add({
      extension = {
        mdx = "mdx",
      },
    })
  end,
}
