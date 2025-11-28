{
  pkgs,
  config,
  useNixGl,
  ...
}: let
  constants = import ../constants.nix;
in {
  # https://mipmip.github.io/home-manager-option-search/?query=kitty
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    package =
      if useNixGl
      then config.lib.nixGL.wrap pkgs.kitty
      else pkgs.kitty;
    font = {
      # Show current fonts installed : kitty --debug-font-fallback
      name = constants.font;
      size = 16; # 14 - 20
    };
    settings = {
      hide_window_decorations =
        if pkgs.stdenv.isDarwin
        then "titlebar-only"
        else true;
      placement_strategy = "top-left";
      window_padding_width = "1 0 0";
      shell = "${pkgs.fish}/bin/fish";
      # shell = "${pkgs.nushell}/bin/nu";
    };
    themeFile = "Solarized_Dark_Higher_Contrast";
    extraConfig = ''
      background ${constants.colors.background}
      cursor ${constants.colors.cursor}
    '';
  };
}
