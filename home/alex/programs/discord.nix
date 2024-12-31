{
  pkgs,
  utils,
  host,
  ...
}: let
  discord = pkgs.discord;
  bin = "${discord}/bin/discord";
in {
  home.packages = [
    discord
  ];

  xdg.dataFile."applications/discord.desktop" = {
    enable = host.useNixGL;
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Discord
      GenericName=Social App
      Comment=Chat for Communities and Friends
      TryExec=${bin}
      Exec=${bin}
      Icon=${discord}/share/icons/hicolor/256x256/apps/discord.png
      Categories=Games;Social;
    '';
  };
}
