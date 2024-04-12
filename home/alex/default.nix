{
  # osConfig # Added by home-manager
  pkgs,
  vars,
  utils,
  isManagedByHomeManager,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (vars) username editor;
in {
  imports = [
    ./programs
    ./config.nix
    ./packages.nix
    ./kavval-packages.nix
    ./files
    ./scripts
  ];

  # Recommended for linux distros other than NixOS
  targets.genericLinux.enable = isLinux && isManagedByHomeManager;

  home.username = username;
  home.homeDirectory = utils.getHomeDir {inherit isDarwin username;};

  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

  # Create folders
  home.file."dev/.keep".text = "keep";

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
  home.sessionVariables = {
    EDITOR = editor;
  };
}
