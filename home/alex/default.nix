{
  # inputs,
  # outputs,
  # lib,
  # config,
  # osConfig # Added by home-manager
  vars,
  utils,
  ...
}: let
  inherit (utils) isDarwin isLinux isNixOs;
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
  targets.genericLinux.enable = !isNixOs && isLinux;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    inherit username;
    homeDirectory =
      if isDarwin
      then "/Users/${username}"
      else "/home/${username}";
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # TODO: Replace this values with the generated one in "~/.config/home-manager/home.nix"
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  # home.stateVersion = "23.05";
}
