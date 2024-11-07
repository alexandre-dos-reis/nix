{
  pkgs,
  user,
  utils,
  host,
  inputs,
  config,
  ...
}: {
  imports = [
    ./overlays.nix
    ./programs
    ./packages.nix
    ./kavval-packages.nix
    ./files
    ./scripts
  ];
  nixpkgs.config.allowUnfree = true;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # Recommended for linux distros other than NixOS
  targets.genericLinux.enable = utils.isLinux && host.isManagedByHomeManager;
  xdg.enable = true;

  programs = {
    home-manager.enable = true;
  };

  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

    username = user.username;
    homeDirectory = user.homeDir;

    file."dev/.keep".text = "keep"; # Create folders

    sessionVariables = {
      EDITOR = user.editor;
      FLAKE = "${user.homeDir}/dev/nix-conf";
      TERMINAL_BG = user.colors.background;
    };

    # https://mipmip.github.io/home-manager-option-search/?query=keyboard
    # https://dev.to/tallesl/change-caps-lock-to-ctrl-3c4
    # https://www.reddit.com/r/NixOS/comments/trkfyz/overriding_configurationnix_with_homemanager/
    keyboard.layout =
      if utils.isDarwin
      then "Unicode Hex Input"
      else "us";

    packages = with pkgs; [
      (maple-mono-NF.overrideAttrs {
        version = "7.0-beta29";
      })
      (nerdfonts.override {
        fonts = [
          "Meslo"
          "JetBrainsMono"
        ];
      })
    ];
  };
}
