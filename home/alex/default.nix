{
  user,
  helpers,
  inputs,
  ...
}: {
  imports = [
    ./programs
    ./packages.nix
    ./files
    ./scripts
    # ./kavval-packages.nix
    # ./office.nix
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
    };

    sessionVariables = {
      EDITOR = user.editor;
      TERMINAL_BG = user.colors.background;
      CAROOT = "${user.homeDir}/.local/share/mkcert";
      # TODO: See if this is causing an error.
      # XCURSOR_SIZE = user.cursor.size;
    };

    # https://mipmip.github.io/home-manager-option-search/?query=keyboard
    # https://dev.to/tallesl/change-caps-lock-to-ctrl-3c4
    # https://www.reddit.com/r/NixOS/comments/trkfyz/overriding_configurationnix_with_homemanager/
    keyboard.layout =
      if helpers.isDarwin
      then "Unicode Hex Input"
      else "us";
  };
}
