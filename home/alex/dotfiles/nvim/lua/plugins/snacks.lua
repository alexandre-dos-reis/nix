return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
  keys = {
    {
      "<leader>rf",
      ---@diagnostic disable: undefined-global
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
  },
  init = function()
    -- Delete orphan buffers, not attach to tab nor win
    -- Ref: https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bufdelete.lua
    require("utils").augroup("rm_orphan_buffers", function(autocmd)
      autocmd("BufEnter", {
        callback = function(e)
          local buf = e.buf
          local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
          local name = vim.api.nvim_buf_get_name(buf)

          -- Continue only for real file buffer
          if buftype == "" and name ~= "" then
            local win_buffers = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              win_buffers[vim.api.nvim_win_get_buf(win)] = true
            end

            -- TODO: Remove
            -- For each buffer
            Snacks.bufdelete.delete({
              force = true,
              filter = function(b)
                if
                  -- Don't delete the current buffer
                  buf == b
                  -- Don't delete buffer present in other window
                  or win_buffers[b]
                then
                  return false
                end

                -- Delete orphan code buffer
                if vim.api.nvim_buf_get_name(b) == "" then
                  return true
                end

                -- Autosave before deleting
                if vim.bo[b].modified then
                  vim.api.nvim_buf_call(b, vim.cmd.write)
                end

                -- Delete
                return true
              end,
            })
          end
        end,
      })
    end)
  end,
}
