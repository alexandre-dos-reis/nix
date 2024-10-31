{
  pkgs,
  user,
  utils,
  host,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
  homeDir = utils.getHomeDir {inherit isDarwin user;};
in {
  imports = [
    ./programs
    ./packages.nix
    ./kavval-packages.nix
    ./files
    ./scripts
  ];
  nixpkgs.config.allowUnfree = true;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # Recommended for linux distros other than NixOS
  targets.genericLinux.enable = isLinux && host.isManagedByHomeManager;
  xdg.enable = true;

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs, is this usefull ?
  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

    username = user.username;
    homeDirectory = homeDir;

    file."dev/.keep".text = "keep"; # Create folders

    sessionVariables = {
      EDITOR = user.editor;
      FLAKE = "${homeDir}/dev/nix-conf";
    };

    # https://mipmip.github.io/home-manager-option-search/?query=keyboard
    # https://dev.to/tallesl/change-caps-lock-to-ctrl-3c4
    # https://www.reddit.com/r/NixOS/comments/trkfyz/overriding_configurationnix_with_homemanager/
    keyboard.layout =
      if isDarwin
      then "Unicode Hex Input"
      else "us";

    packages = [
      (pkgs.nerdfonts.override {
        fonts = [
          "Meslo"
          user.font.nerdFontName
        ];
      })
    ];
  };
}
