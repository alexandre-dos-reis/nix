local M = {}

--- Creates an autocmd group that will automatically group and clear the
--- autocmds created within it.
--- @param name string
--- @param func fun(autocmd: fun(event: any, opts: vim.api.keyset.create_autocmd))
function M.augroup(name, func)
  local group = vim.api.nvim_create_augroup(name, { clear = true })
  --- @param event any
  --- @param opts vim.api.keyset.create_autocmd
  local function autocmd(event, opts)
    vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", opts, { group = group }))
  end

  func(autocmd)
end

--- Set multiple keymaps at once.
--- @alias KeymapTuple { [1]: string|string[], [2]: string, [3]: string|function, [4]?: string }
--- @param keymaps KeymapTuple[]
function M.set_keymaps(keymaps)
  for _, keymap in ipairs(keymaps) do
    vim.keymap.set(keymap[1], keymap[2], keymap[3], { desc = keymap[4] or nil })
  end
end

return M
