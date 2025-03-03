{pkgs, ...}: {
  # TODO: https://www.youtube.com/watch?v=zt3hgSBs11g
  # For now just tweak the config file in `~/.config/hypr/hyprland.conf`

  # wayland.windowManager.hyprland = {
  #   enable = true;
  # };

  # App launcher
  programs.wofi.enable = true;
  # Status bar
  programs.waybar = {
    enable = true;
    style = ./waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        # modules-center = ["hyprland/window"];
        modules-right = ["hyprland/language" "custom/weather" "pulseaudio" "battery" "clock" "tray"];

        "hyprland/workspaces" = {
          # I'm using icons just to rename workspaces
          format = "{icon}";
          format-icons = {
            "1" = "work";
            "2" = "com";
            "3" = "3";
            "4" = "4";
            # "5" = "5";
            "6" = "work";
            "7" = "com";
            "8" = "3";
            "9" = "4";
            # "10" = "5";
          };
          active-only = false;
          disable-scroll = true;
          show-special = true;
          # special-visible-only = true;
          all-outputs = false;
          persistent-workspaces = {
            "eDP-1" = [
              1
              2
              # 3
              # 4
              # 5
            ];
            "DP-4" = [
              6
              7
              # 8
              # 9
              # 10
            ];
          };
        };
      };
    };
  };

  services.clipman.enable = true;

  # TUI-based clipboard manager
  home.packages = [
    pkgs.clipse
    pkgs.wl-clipboard
  ];
}
