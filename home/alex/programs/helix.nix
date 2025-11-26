{pkgs, ...}: {
  programs.helix = {
    enable = true;
    package = pkgs.evil-helix;
    settings = {
      theme = "solarized_dark";
      editor = {
        evil = true;
      };
      keys.normal = {
        "S-k" = "hover";
      };
      # ui = {
      #   background = user.colors.background;
      #   cursor = user.colors.cursor;
      # };
    };
  };
}
