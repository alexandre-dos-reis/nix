{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # TODO: use xdg config
  home.file.".config/nvim" = {
    source = ./config;
    recursive = true;
  };
}
