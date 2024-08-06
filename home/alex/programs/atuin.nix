{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      keymap_mode = "vim-insert";
      keys = {
        scroll_exits = false;
      };
      history_filter = [
        "c"
        "clear"
      ];
    };
  };
}
