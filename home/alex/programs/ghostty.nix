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
  programs.ghostty = {
    enable = true;
    package =
      if host.useNixGL
      then config.lib.nixGL.wrap ghostty
      else ghostty;
    enableFishIntegration = true;
    settings = {
      # command = "${pkgs.nushell}/bin/nu";
      command = "${pkgs.fish}/bin/fish";
      gtk-single-instance = false; # On linux enable multi instances
      theme = "Solarized Dark Higher Contrast";
      font-size = 16; # 22
      font-family = user.font;
      background = user.colors.background;
      cursor-color = user.colors.cursor;
      cursor-style = "block";
      cursor-style-blink = false;
      window-decoration = false;
      window-padding-x = 0; # 10
      window-padding-y = 0;
      window-padding-color = "extend";
      mouse-hide-while-typing = true;
    };
  };
}
