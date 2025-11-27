{
  users,
  pkgs,
  useNixGl,
  config,
  ...
}: let
  user = users.alex;
in {
  programs.ghostty = {
    enable = true;
    package =
      if useNixGl
      then config.lib.nixGL.wrap pkgs.ghostty
      else pkgs.ghostty;
    enableFishIntegration = true;
    settings = {
      command = "${pkgs.fish}/bin/fish";
      gtk-single-instance = false; # On linux enable multi instances
      theme = "Solarized Dark Higher Contrast";
      maximize = true;
      font-size = 16; # 22
      font-family = user.font;
      background = user.colors.background;
      shell-integration-features = "no-cursor, sudo, title";
      cursor-color = user.colors.cursor;
      cursor-style = "block";
      cursor-style-blink = false;
      window-decoration = false;
      window-padding-x = 0; # 10
      window-padding-y = 0;
      window-padding-color = "extend";
      mouse-hide-while-typing = true;
      app-notifications = ["no-clipboard-copy"];
    };
  };
}
