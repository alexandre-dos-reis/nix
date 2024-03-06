{
  # https://mipmip.github.io/home-manager-option-search/?query=kitty
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "JetBrainsMono";
      size = 20;
    };
    settings = {
      hide_window_decorations = "titlebar-only";
      shell = "/run/current-system/sw/bin/fish";
    };
    # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    # https://github.com/kovidgoyal/kitty-themes/blob/master/themes.json
    # Use the name attribute from the json file
    theme = "Solarized Dark - Patched";
  };
}
