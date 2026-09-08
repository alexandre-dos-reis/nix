return {
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    keys = {
      {
        "<leader>go",
        "<Cmd>GBrowse<CR>",
        mode = { "n" },
        desc = "Open current remote file on browser",
      },
      {
        "<leader>go",
        ":'<,'>GBrowse<CR>",
        mode = { "v" },
        desc = "Open current remote file on browser with current line selected",
      },
      {
        "<leader>gp",
        function()
          -- INFO: Run the job async
          vim.fn.jobstart({ "gh", "pr", "view", "--web" }, { detach = true })
        end,
        desc = "Open current github pull request on browser",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map("n", "<leader>gj", gs.next_hunk, "Next git hunk")
        map("n", "<leader>gk", gs.prev_hunk, "Prev git hunk")

        -- TODO: Inspect...

        -- Actions
        -- map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        -- map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        -- map("v", "<leader>hs", function()
        --   gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        -- end, "Stage hunk")
        -- map("v", "<leader>hr", function()
        --   gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        -- end, "Reset hunk")
        --
        -- map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        -- map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        --
        -- map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        --
        -- map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        --
        -- map("n", "<leader>hb", function()
        --   gs.blame_line({ full = true })
        -- end, "Blame line")
        -- map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
        --
        -- map("n", "<leader>hd", gs.diffthis, "Diff this")
        -- map("n", "<leader>hD", function()
        --   gs.diffthis("~")
        -- end, "Diff this ~")
        --
        -- -- Text object
        -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
      end,
    },
  },
}
