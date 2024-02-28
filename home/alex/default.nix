{
  # inputs,
  # outputs,
  # lib,
  # config,
  pkgs,
  globals,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  username = (globals) username;
in {
  imports = [
    ./programs
    ./packages
  ];

  # TODO: We need to test if we are on NON-NIX-OS-LINUX-OS
  targets.genericLinux.enable = if isLinux then true else false;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    inherit username;
    homeDirectory = if isDarwin then 
        "/Users/${username}"
      else
        "/home/${username}";
  };


  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # TODO: Replace this values with the generated one in "~/.config/home-manager/home.nix"
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
