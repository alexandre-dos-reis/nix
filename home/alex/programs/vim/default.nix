{
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./config.vim;
  };
}
