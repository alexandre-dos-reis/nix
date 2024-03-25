{pkgs, ...}: let
  kitty = "${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa ${pkgs.kitty}/bin/kitty";
  inherit (pkgs.stdenv) isDarwin;
in {
  # https://mipmip.github.io/home-manager-option-search/?query=kitty
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      # Show current fonts installed : kitty --debug-font-fallback
      name = "JetBrainsMono Nerd Font";
      size = 9; #  9 - 12
    };
    settings = {
      hide_window_decorations =
        if isDarwin
        then "titlebar-only"
        else true;
      shell = "/home/alex/.nix-profile/bin/fish";
    };
    # Use the name attribute from the json file to the theme key.
    # https://github.com/kovidgoyal/kitty-themes/blob/master/themes.json
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
