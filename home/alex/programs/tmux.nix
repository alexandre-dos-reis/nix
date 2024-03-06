{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    shell = "\${pkgs.fish}/bin/fish";
    plugins = with pkgs.tmuxPlugins; [
      continuum
      vim-tmux-navigator
      resurrect
    ];
    historyLimit = 10000;
    mouse = true;
    extraConfig = ''
      set -g set-clipboard on  # use system clipboard

      # Change split panes commands and open in the current directory
      unbind %
      unbind ')'
      unbind '"'
      bind "|" split-window -h -c " #{pane_current_path}"
      bind - split-window -v -c " #{pane_current_path}"

      # Resize panes
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5

      bind -r m resize-pane -Z  # Fullscreen

      # Moving window
      bind-key -n C-S-Left swap-window -t -1 \; previous-window
      bind-key -n C-S-Right swap-window -t +1 \; next-window

      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on


      # nvim config advised by ":healthcheck"
      # https://github.com/neovim/neovim/wiki/FAQ#esc-in-tmux-or-gnu-screen-is-delayed
      set -s escape-time 0
      set -g status-interval 0
      set -g focus-events on

      # Allow using vim movement in TMUX
      # Example: "Prefix + PgUp" then use vim hjkl to move
      # Also use "shift" to lock cursor
      # Up half page : "Ctrl-u"
      # Down half page : "Ctrl-d"
      # Up page : "Ctrl-b"
      # Down page : "Ctrl-f"
      set-window-option -g mode-keys vi
      bind 'v' copy-mode
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Shortcut for reloading tmux config
      unbind r
      bind r source-file ~/.tmux.conf

      # TPM plugin - https://github.com/tmux-plugins/tpm
      set -g @plugin 'tmux-plugins/tpm'

      ### START OF TMUX PLUGINS ###

      set -g @plugin 'christoomey/vim-tmux-navigator'  # Allow switching panes with vim keys, ex: "ctrl + h,j,k,l"

      set -g @plugin 'tmux-plugins/tmux-resurrect'  # Persist tmux session after computer restart: Key bindings
      # Key bindings
      # Save: prefix + Ctrl-s
      # Restore: prefix + Ctrl-r

      set -g @plugin 'tmux-plugins/tmux-continuum'  # auto saves session every 15 minutes

      # set -g @plugin 'jimeh/tmux-themepack' # Install custom theme for tmux
      # set -g @plugin 'catppuccin/tmux' # catppuccin theme

      set -g @themepack 'powerline/default/cyan'

      ### END OF TMUX PLUGINS ###

      # !!! #
      # Install plugins with "Prefix + Shift-i"
      # Initialize TMUX plugin manager (KEEP THIS LINE AT THE VERY BOTTOM OF tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'


      ## StatusLine
      # vim: ft=tmux
        set -g mode-style "fg=#eee8d5,bg=#073642"

        set -g message-style "fg=#eee8d5,bg=#073642"
        set -g message-command-style "fg=#eee8d5,bg=#073642"

        set -g pane-border-style "fg=#073642"
        set -g pane-active-border-style "fg=#eee8d5"

        set -g status "on"
        set -g status-interval 1
        set -g status-justify "left"

        set -g status-style "fg=#586e75,bg=#073642"

        set -g status-bg "#002b36"

        set -g status-left-length "100"
        set -g status-right-length "100"

        set -g status-left-style NONE
        set -g status-right-style NONE

        set -g status-left "#[fg=#073642,bg=#eee8d5,bold] #S #[fg=#eee8d5,bg=#93a1a1,nobold,nounderscore,noitalics]#[fg=#15161E,bg=#93a1a1,bold] #(whoami) #[fg=#93a1a1,bg=#002b36]"
        set -g status-right "#[fg=#586e75,bg=#002b36,nobold,nounderscore,noitalics]#[fg=#93a1a1,bg=#586e75]#[fg=#657b83,bg=#586e75,nobold,nounderscore,noitalics]#[fg=#93a1a1,bg=#657b83]#[fg=#93a1a1,bg=#657b83,nobold,nounderscore,noitalics]#[fg=#15161E,bg=#93a1a1,bold] #h "

        setw -g window-status-activity-style "underscore,fg=#839496,bg=#002b36"
        setw -g window-status-separator ""
        setw -g window-status-style "NONE,fg=#839496,bg=#002b36"
        setw -g window-status-format '#[fg=#002b36,bg=#002b36]#[default] #I  #{b:pane_current_path} #[fg=#002b36,bg=#002b36,nobold,nounderscore,noitalics]'
        setw -g window-status-current-format '#[fg=#002b36,bg=#eee8d5]#[fg=#b58900,bg=#eee8d5] #I #[fg=#eee8d5,bg=#b58900] #{b:pane_current_path} #[fg=#b58900,bg=#002b36,nobold]'
    '';
  };
}
