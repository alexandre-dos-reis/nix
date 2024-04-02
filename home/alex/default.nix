{
  # inputs,
  # outputs,
  # lib,
  # config,
  # osConfig # Added by home-manager
  pkgs,
  vars,
  utils,
  ...
}: let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (utils) isNixOs;
  inherit (vars) username editor;
in {
  imports = [
    ./programs
    ./config.nix
    ./packages.nix
    ./kavval-packages.nix
    ./files
  ];

  # Recommended for linux distros other than NixOS
  targets.genericLinux.enable = true;

  home.username = username;
  home.homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

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
