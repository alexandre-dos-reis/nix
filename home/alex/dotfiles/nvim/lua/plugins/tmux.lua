return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  -- The <C-h/j/k/l> mappings now live in after/plugin/herdr_nav.lua, which
  -- picks tmux, herdr or the Herdr app depending on what we are running in.
  -- The plugin is still loaded eagerly so its TmuxNavigate* commands exist
  -- for that file's tmux branch; it just no longer claims the keys itself.
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
  end,
}
