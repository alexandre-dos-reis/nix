let 
  configPath = ".config/nvim";
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # TODO: Add config folder...
  home.file."${configPath}".source = ./config;
  home.file."${configPath}".recursive = true;
}
