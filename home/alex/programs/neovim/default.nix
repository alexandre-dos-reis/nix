{
  # TODO: https://github.com/LazyVim/LazyVim/discussions/1972
  programs.neovim = {
    enable = false;
    defaultEditor = true;
  };

  # TODO: use xdg config
  # home.file.".config/nvim" = {
  # source = ./config;
  # recursive = true;
  #};
}
