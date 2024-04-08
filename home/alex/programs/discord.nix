{
  pkgs,
  utils,
  ...
}: let
  discord = pkgs.discord;
  icon = "${discord}/share/icons/hicolor/256x256/apps/discord.png";
  bin = "${discord}/bin/discord";

  inherit (utils) isOtherLinuxOs;
in {
  home.packages = [
    discord
  ];

  xdg.dataFile."applications/discord.desktop" = {
    enable = isOtherLinuxOs;
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Discord
      GenericName=Social App
      Comment=Chat for Communities and Friends
      TryExec=${bin}
      Exec=${bin}
      Icon=${icon}
      Categories=Games;Social;
    '';
  };
}
