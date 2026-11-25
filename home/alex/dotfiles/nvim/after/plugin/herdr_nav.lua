-- vim-herdr-navigation — Neovim side
-- Vendored from https://github.com/paulbkim-dev/vim-herdr-navigation (editor/nvim.lua).
-- Lives in after/plugin so it is mapped last and wins over vim-tmux-navigator.
--
-- <C-h/j/k/l> move between Neovim splits; at a split edge they hand off to
-- whatever is around us:
--   REX_BLOCK      -> Rex/Renux (rex do focus_pane_direct)
--   HERDR_PANE_ID  -> the herdr TUI (herdr pane focus)
--   HC_TERMINAL_ID -> the Herdr desktop app (herdr-app do pane.go)
--   TMUX           -> vim-tmux-navigator, exactly as before
-- Outside all four the keys just move splits.
--
-- Rex binds the same keys itself, so it only gets this far because its
-- focus_pane action types the key into the pane when an editor is running in
-- it; see rex/editor-nav.lua. We call focus_pane_direct rather than
-- focus_pane so it doesn't do that again and bounce the key back here.

local function nav(wincmd, dir)
  local prev = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)
  if vim.api.nvim_get_current_win() ~= prev then
    return -- moved within Neovim
  end
  -- At a split edge: cross into the surrounding multiplexer.
  if vim.env.REX_BLOCK and vim.env.REX_BLOCK ~= "" then
    -- Name our own block twice: -b is the block the action applies to, and -s
    -- takes a block ID too and resolves it to the session holding it, so this
    -- works whatever Rex variables the shell passed on. Detached, so the
    -- editor never blocks on the round trip.
    local id = vim.env.REX_BLOCK
    local act = "focus_pane_direct"
    local argv = { "rex", "do", act, "direction=" .. dir, "-s", id, "-b", id }
    vim.system(argv, nil, function(res)
      if res.code ~= 0 then
        local msg = "rex " .. act .. ": " .. (res.stderr or "")
        vim.schedule(function()
          vim.notify(msg, vim.log.levels.WARN)
        end)
      end
    end)
  elseif vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == "" then
      herdr = "herdr"
    end
    -- Target this pane explicitly: `--current` resolves to the server's
    -- globally focused pane, which is not necessarily the one we are in.
    vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--pane", vim.env.HERDR_PANE_ID })
  elseif vim.env.HC_TERMINAL_ID and vim.env.HC_TERMINAL_ID ~= "" then
    vim.fn.system({ "herdr-app", "do", "pane.go", "--direction", dir })
  elseif vim.env.TMUX and vim.env.TMUX ~= "" then
    local tmux = { left = "Left", down = "Down", up = "Up", right = "Right" }
    pcall(vim.cmd, "TmuxNavigate" .. tmux[dir])
  end
end

local function map(lhs, wincmd, dir, desc)
  vim.keymap.set("n", lhs, function()
    nav(wincmd, dir)
  end, { silent = true, noremap = true, desc = desc })
end

map("<C-h>", "h", "left", "Navigate left (vim/herdr)")
map("<C-j>", "j", "down", "Navigate down (vim/herdr)")
map("<C-k>", "k", "up", "Navigate up (vim/herdr)")
map("<C-l>", "l", "right", "Navigate right (vim/herdr)")
