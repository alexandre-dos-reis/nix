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
    # https://github.com/Alexays/Waybar/wiki/Module:-Hyprland
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
          active-only = false;
          all-outputs = false;
          # I'm using icons just to rename workspaces
          format = "{icon}";
          format-icons = let
            work = "Work";
            com = "Com";
          in {
            "1" = work;
            "2" = com;
            "3" = "3";
            "4" = "4";
            # "5" = "5";
            "6" = work;
            "7" = com;
            "8" = "8";
            "9" = "9";
            # "10" = "5";
          };
          disable-scroll = true;
          show-special = true;
          # special-visible-only = true;
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
