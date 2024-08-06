{
  pkgs,
  inputs,
  vars,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.nvim-nightly.packages.${pkgs.system}.default;
  };

  # xdg.configFile.nvim = {
  #   source = ./config;
  #   recursive = true;
  # };

  # https://github.com/nix-community/nixd/blob/main/nixd/docs/user-guide.md#configuration
  home.packages = with pkgs; [
    nixd ## nix lsp
  ];
}
