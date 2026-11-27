local augroup = require("utils").augroup

-- Remove concealled quotes, d-quotes, backticks, etc...
augroup("rm_concealed", function(autocmd)
  autocmd("FileType", {
    pattern = { "json", "jsonc", "mdx", "markdown" },
    callback = function()
      vim.wo.spell = false
      vim.wo.conceallevel = 0
    end,
  })
end)

-- Set wrap and spell to content files like markdown, etc.
augroup("content_files", function(autocmd)
  autocmd("FileType", {
    pattern = { "gitcommit", "markdown", "md", "pandoc" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = false
    end,
  })
end)

-- Small animate on yank
augroup("HighlightYank", function(autocmd)
  autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({
        higroup = "IncSearch",
        timeout = 40,
      })
    end,
  })
end)
