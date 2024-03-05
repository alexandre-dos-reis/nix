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
  inherit (utils)  isNixOs;
  inherit (vars) username;
in {
  # imports = [
  #   ./config.nix
  #   ./packages.nix
  #   ./kavval-packages.nix
  #   ./programs
  #   ./files
  # ];

  # Recommended for linux distros other than NixOS
  #targets.genericLinux.enable = !isNixOs && isLinux;

  # home = {
  #  inherit username;
  #  homeDirectory =
  #    if isDarwin
  #    then "/Users/${username}"
  #    else "/home/${username}";
  #};

  programs = {
    home-manager.enable = true;
   neovim.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # TODO: Replace this values with the generated one in "~/.config/home-manager/home.nix"
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
