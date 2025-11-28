{
  inputs,
  pkgs,
  config,
  useNixGL,
  ...
}: let
  constants = import ./constants.nix;
  isDarwin = pkgs.stdenv.isDarwin;
in {
  imports =
    [
      ./programs
      ./packages.nix
      ./files
      ./scripts
    ]
    ++ (
      if !useNixGL
      then [./hyprland]
      else []
    );

  nixpkgs.config.allowUnfree = true;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  xdg.enable = true;

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    homeDirectory =
      if isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}";

    sessionVariables = {
      EDITOR = constants.editor;
      TERMINAL_BG = constants.colors.background;
      CAROOT = "${config.home.homeDirectory}/.local/share/mkcert";
    };

    # https://mipmip.github.io/home-manager-option-search/?query=keyboard
    # https://dev.to/tallesl/change-caps-lock-to-ctrl-3c4
    # https://www.reddit.com/r/NixOS/comments/trkfyz/overriding_configurationnix_with_homemanager/
    keyboard.layout =
      if isDarwin
      then "Unicode Hex Input"
      else "us";
  };
}
