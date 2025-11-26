{
  pkgs,
  user,
  ...
}: let
  # term = "xterm-kitty";
  # https://github.com/craftzdog/dotfiles-public/blob/master/.config/tmux/tmux.conf
  # term = "xterm-256color";
  term = "xterm-ghostty";
  bg = user.colors.background;
  fg = user.colors.palette.base2-hex;
  yellow = user.colors.palette.yellow-hex;
  grey = user.colors.palette.base1-hex;
  colors = user.colors.palette;
in {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    shell = "${pkgs.fish}/bin/fish";
    # shell = "${pkgs.nushell}/bin/nu";
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];
    historyLimit = 10000;
    mouse = true;
    extraConfig = ''
      set -g default-terminal "${term}"
      set -ga terminal-overrides ",${term}:Tc"
      # set -as terminal-features ",${term}:RGB"

      set -g set-clipboard on  # use system clipboard

      # Change split panes commands and open in the current directory
      unbind %
      unbind ')'
      unbind '"'
      bind "|" split-window -c '#{pane_current_path}' -h
      bind - split-window -c '#{pane_current_path}' -v

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

      # from yazi: https://yazi-rs.github.io/docs/image-preview/#tmux
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

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
      bind r source-file ~/.config/tmux/tmux.conf

      # Undercurl
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      # Globals Shortcuts that works without the tmux prefix
      # https://github.com/edr3x/tmux-sessionizer?tab=readme-ov-file
      # `-n` bypass the prefix-key
      bind-key -n C-f run-shell "tmux neww ~/bin/tmux-sessionizer"
      bind-key -n C-m run-shell "tmux copy-mode"

      # Enable kitty image protocol to work, see: https://www.youtube.com/watch?v=nYDMXI-yFTA
      set -gq allow-passthrough on

      ## style and colors
        set -g mode-style "fg=${fg},bg=${bg}"

        set -g message-style "fg=${fg},bg=${bg}"
        set -g message-command-style "fg=${fg},bg=${bg}"

        set -g pane-border-style "fg=${bg}"
        set -g pane-active-border-style "fg=${grey}"

        set -g status "on"
        set -g status-interval 1
        set -g status-justify "left"

        set -g status-style "fg=${grey},bg=${bg}"

        set -g status-bg "${bg}"

        set -g status-left-length "100"
        set -g status-right-length "100"

        set -g status-left-style NONE
        set -g status-right-style NONE

        set -g status-left "#[fg=${colors.base1-hex},bg=${colors.base02-hex},bold] #S #[fg=${colors.base02-hex},bg=${colors.base03-hex},nobold,nounderscore,noitalics]#[fg=${colors.base1-hex},bg=${colors.base03-hex},bold] #(whoami) #[fg=${colors.base03-hex},bg=${bg}]"
        set -g status-right "#[fg=${colors.base03-hex},bg=${bg},nobold,nounderscore,noitalics]#[fg=${colors.base02-hex},bg=${colors.base03-hex},nobold,nounderscore,noitalics]#[fg=${colors.base1-hex},bg=${colors.base02-hex},bold] #h "

        setw -g window-status-activity-style "underscore,fg=${grey},bg=${bg}"
        setw -g window-status-separator ""
        setw -g window-status-style "NONE,fg=${grey},bg=${bg}"
        setw -g window-status-format '#[fg=${bg},bg=${bg}]#[fg=${colors.base00-hex},bg=${bg}] #I  #{b:pane_current_command} #[fg=${bg},bg=${bg},nobold,nounderscore,noitalics]'
        setw -g window-status-current-format '#[fg=${bg},bg=${yellow}]#[fg=${colors.base02-hex},bg=${yellow}] #I #[fg=${yellow},bg=${colors.base02-hex}] #{b:pane_current_command} #[fg=${colors.base02-hex},bg=${bg},nobold]'
    '';
  };
}
