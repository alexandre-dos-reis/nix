-- Custom user commands
vim.api.nvim_create_user_command("SetAndFormat", function(opts)
  vim.api.nvim_set_option_value("filetype", opts.args, { buf = 0 })
  pcall(vim.lsp.buf.format, { bufnr = 0 })
end, { nargs = "*" })
