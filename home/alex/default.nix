{
  # osConfig # Added by home-manager
  pkgs,
  vars,
  utils,
  host,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (vars) username editor;
  homeDir = utils.getHomeDir {inherit isDarwin username;};
in {
  imports = [
    ./programs
    ./services
    ./packages.nix
    ./kavval-packages.nix
    ./files
    ./scripts
  ];
  nixpkgs.config.allowUnfree = true;

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

    username = username;
    homeDirectory = homeDir;

    file."dev/.keep".text = "keep"; # Create folders

    sessionVariables = {
      EDITOR = editor;
      FLAKE = "${homeDir}/dev/nix-conf";
    };

    # https://mipmip.github.io/home-manager-option-search/?query=keyboard
    # https://dev.to/tallesl/change-caps-lock-to-ctrl-3c4
    # https://www.reddit.com/r/NixOS/comments/trkfyz/overriding_configurationnix_with_homemanager/
    keyboard.layout = if isDarwin then "Unicode Hex Input" else "us";

    packages = [
      (pkgs.nerdfonts.override {
        fonts = [
          "Meslo"
          vars.font.nerdFontName
        ];
      })
    ];
  };
}
