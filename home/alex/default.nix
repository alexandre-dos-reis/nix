{
  pkgs,
  user,
  helpers,
  inputs,
  ...
}: {
  imports = [
    ./programs
    ./packages.nix
    ./kavval-packages.nix
    ./files
    ./scripts
  ];
  nixpkgs.config.allowUnfree = true;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  xdg.enable = true;

  programs = {
    home-manager.enable = true;
  };

  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

    username = user.username;
    homeDirectory = user.homeDir;

    file = {
      "dev/.keep".text = "keep"; # Create folders
      # "qmk_firmware" = {
      #   source = inputs.qmk;
      #   recursive = true;
      # };
    };

    sessionVariables = {
      EDITOR = user.editor;
      FLAKE = "${user.homeDir}/dev/nix-config";
      TERMINAL_BG = user.colors.background;
    };

    # https://mipmip.github.io/home-manager-option-search/?query=keyboard
    # https://dev.to/tallesl/change-caps-lock-to-ctrl-3c4
    # https://www.reddit.com/r/NixOS/comments/trkfyz/overriding_configurationnix_with_homemanager/
    keyboard.layout =
      if helpers.isDarwin
      then "Unicode Hex Input"
      else "us";

    packages = with pkgs; [
      (maple-mono-NF.overrideAttrs {
        version = "7.0-beta36";
      })
    ];

    pointerCursor = {
      hyprcursor.enable = true;
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.banana-cursor;
      name = "Banana";
      # package = pkgs.bibata-cursors;
      # name = "Bibata-Modern-Classic";
      size = 28;
    };
  };
  gtk = {enable = true;};
}
