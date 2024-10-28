{
  programs.atuin = {
    enable = true;
    # enableFishIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      keymap_mode = "vim-insert";
      # filter_mode_shell_up_key_binding = "session";
      keys = {
        scroll_exits = false;
      };
    };
  };
}
