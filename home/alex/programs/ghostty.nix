{
  pkgs,
  host,
  inputs,
  user,
  ...
}: let
  ghostty = inputs.ghostty.packages.${pkgs.system}.default;
  bin = "${ghostty}/bin/ghostty";

  inherit (host) isNixGlWrapped xdgDataFileEnabled;
  binWrapped =
    if isNixGlWrapped
    then "${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa '${bin}'"
    else bin;
in {
  home.packages = [
    ghostty
  ];

  xdg.dataFile."applications/ghostty.desktop" = {
    enable = host.xdgDataFileEnabled;
    text = ''
      [Desktop Entry]
      Name=Ghostty
      Type=Application
      Comment=A terminal emulator
      Exec=${binWrapped}
      Icon=${ghostty}/share/icons/hicolor/256x256@2/apps/com.mitchellh.ghostty.png
      Categories=System;TerminalEmulator;
      Keywords=terminal;tty;pty;
      StartupNotify=true
      Terminal=false
      Actions=new-window;
      X-GNOME-UsesNotifications=true
    '';
  };

  xdg.configFile."ghostty/config".text = ''
    theme = Solarized Dark Higher Contrast

    font-size = 16
    font-family = ${user.font}

    background = ${user.colors.background}

    cursor-color = ${user.colors.cursor}
    cursor-style = block
    cursor-style-blink = false

    window-decoration = false
    window-padding-x = 10
    window-padding-y = 5
    window-padding-color = extend
  '';
}
