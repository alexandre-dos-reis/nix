{
  pkgs,
  user,
  host,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (host) isNixGlWrapped xdgDataFileEnabled;
  kittyBin = "${pkgs.kitty}/bin/kitty";
  kittyBinWrapped =
    if isNixGlWrapped
    then "${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa ${kittyBin}"
    else kittyBin;
in {
  # https://mipmip.github.io/home-manager-option-search/?query=kitty
  programs.kitty = {
    enable = true;
    # shellIntegration.enableFishIntegration = true;
    font = {
      # Show current fonts installed : kitty --debug-font-fallback
      name = user.font.systemName;
      # size = 10;
      size = 12;
    };
    settings = {
      hide_window_decorations =
        if isDarwin
        then "titlebar-only"
        else true;
      placement_strategy = "top-left";
      window_padding_width = "1 0 0";
      # shell = "${pkgs.fish}/bin/fish";
      shell = "${pkgs.nushell}/bin/nu";
    };
    themeFile = "Solarized_Dark_Higher_Contrast";
    extraConfig = let
      inherit (user) colors;
    in ''
      background ${colors.background}
      cursor ${colors.cursor}
    '';
  };

  home.shellAliases.kitty = kittyBinWrapped;
  home.sessionVariables.TERMINAL = "kitty";

  xdg.dataFile."applications/kitty.desktop" = {
    enable = xdgDataFileEnabled;
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=kitty
      GenericName=Terminal emulator
      Comment=Fast, feature-rich, GPU based terminal
      TryExec=${kittyBin}
      # Disable kitty builtin unicode editor
      Exec=env GLFW_IM_MODULE=ibus ${kittyBinWrapped}
      Icon=${pkgs.kitty}/share/icons/hicolor/scalable/apps/kitty.svg
      Categories=System;TerminalEmulator;
    '';
  };
}
