{
  pkgs,
  host,
  inputs,
  user,
  config,
  ...
}: let
  ghostty = inputs.ghostty.packages.${pkgs.system}.default;
in {
  imports = [
    inputs.ghostty-hm-module.homeModules.default
  ];

  programs.ghostty = {
    enable = true;
    package =
      if host.useNixGL
      then config.lib.nixGL.wrap ghostty
      else ghostty;
    shellIntegration = {
      enable = true;
      enableFishIntegration = true;
    };
    settings = {
      theme = "Solarized Dark Higher Contrast";
      font-size = 22;
      font-family = user.font;
      background = user.colors.background;
      cursor-color = user.colors.cursor;
      cursor-style = "block";
      cursor-style-blink = false;
      window-decoration = false;
      window-padding-x = 10;
      window-padding-y = 0;
      window-padding-color = "extend";
    };
  };
}
