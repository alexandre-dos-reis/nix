{
  pkgs,
  host,
  inputs,
  user,
  ...
}: {
  imports = [
    inputs.ghostty-hm-module.homeModules.default
  ];

  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.default;
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
