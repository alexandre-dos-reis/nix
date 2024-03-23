{pkgs, ...}: let
  kitty = "${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa ${pkgs.kitty}/bin/kitty";
  inherit (pkgs.stdenv) isDarwin;
  # theme = builtins.readFile(builtins.fetchurl {
  #     url = "https://raw.githubusercontent.com/craftzdog/solarized-osaka.nvim/main/extras/kitty/solarized-osaka_night.conf";
  #     sha256 = "sha256:0x6jv0ry2lynd9py6blsif3pplgbmmf45f7sysxdqqw3093mfa6r";
  # });
in {
  # https://mipmip.github.io/home-manager-option-search/?query=kitty
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      # Show current fonts installed : kitty --debug-font-fallback
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      hide_window_decorations =
        if isDarwin
        then "titlebar-only"
        else true;
      shell = "/home/alex/.nix-profile/bin/fish";
    };
    # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    # https://github.com/kovidgoyal/kitty-themes/blob/master/themes.json
    # Use the name attribute from the json file
    theme = "Solarized Dark Higher Contrast";
    extraConfig = ''
      cursor #708183
    '';
  };

  home.shellAliases.kitty = kitty;
  home.sessionVariables.TERMINAL = "kitty";

  xdg.enable = true;
  xdg.dataFile."applications/kitty.desktop" = {
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=kitty
      GenericName=Terminal emulator
      Comment=Fast, feature-rich, GPU based terminal
      TryExec=${pkgs.kitty}/bin/kitty
      Exec=${kitty}
      Icon=${pkgs.kitty}/share/icons/hicolor/scalable/apps/kitty.svg
      Categories=System;TerminalEmulator;
    '';
  };
}
