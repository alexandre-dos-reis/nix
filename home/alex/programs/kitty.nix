{
  pkgs,
  user,
  host,
  helpers,
  config,
  ...
}: {
  # https://mipmip.github.io/home-manager-option-search/?query=kitty
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    package =
      if host.useNixGL
      then config.lib.nixGL.wrap pkgs.kitty
      else pkgs.kitty;
    font = {
      # Show current fonts installed : kitty --debug-font-fallback
      name = user.font;
      size = 16; # 14 - 20
    };
    settings = {
      hide_window_decorations =
        if helpers.isDarwin
        then "titlebar-only"
        else true;
      placement_strategy = "top-left";
      window_padding_width = "1 0 0";
      # shell = "${pkgs.fish}/bin/fish";
      shell = "${pkgs.nushell}/bin/nu";
    };
    themeFile = "Solarized_Dark_Higher_Contrast";
    extraConfig = ''
      background ${user.colors.background}
      cursor ${user.colors.cursor}
    '';
  };
}
